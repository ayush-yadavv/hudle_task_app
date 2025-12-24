import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hudle_task_app/data/repository/geolocation_repository.dart';
import 'package:hudle_task_app/data/repository/weather_repository.dart';
import 'package:hudle_task_app/domain/models/location_model.dart';
import 'package:hudle_task_app/domain/models/weather_model.dart';
import 'package:hudle_task_app/utils/constants/app_configs.dart';
import 'package:hudle_task_app/utils/constants/app_enums.dart';
import 'package:hudle_task_app/utils/exceptions/api_exception.dart';
import 'package:hudle_task_app/utils/logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'weather_event.dart';
part 'weather_state.dart';

/// BLoC that manages the weather-related states and logic of the application.
///
/// It coordinates data fetching between [WeatherRepository] and [GeolocationRepository].
/// Key functionalities include:
/// - Fetching weather by city name (resolving to coordinates first).
/// - Fetching weather directly by coordinates.
/// - Managing location search and search history.
/// - Handling pull-to-refresh and cache logic.
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository _weatherRepository;
  final GeolocationRepository _geolocationRepository;
  WeatherModel? _currentWeather;

  WeatherBloc({
    required WeatherRepository weatherRepository,
    required GeolocationRepository geolocationRepository,
  }) : _weatherRepository = weatherRepository,
       _geolocationRepository = geolocationRepository,
       super(WeatherInitial()) {
    TLogger.info('WeatherBloc initialized');
    on<LoadInitialWeatherEvent>(_onLoadInitialWeather);
    on<FetchWeatherByCityEvent>(_onFetchWeatherByCity);
    on<FetchWeatherByCoordinatesEvent>(_onFetchWeatherByCoordinates);
    on<RefreshWeatherEvent>(_onRefreshWeather);
    on<SearchLocationsEvent>(
      _onSearchLocations,
      transformer: (events, mapper) {
        return events
            .debounceTime(const Duration(milliseconds: 500))
            .asyncExpand(mapper);
      },
    );
    on<LoadSearchHistoryEvent>(_onLoadSearchHistory);
    on<RemoveFromHistoryEvent>(_onRemoveFromHistory);
  }

  /// Handles the [LoadInitialWeatherEvent] to restore the last viewed location or use a default one.
  Future<void> _onLoadInitialWeather(
    LoadInitialWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    TLogger.info('Event: LoadInitialWeatherEvent');

    // Get last selected location from persistence, or use default
    final lastLocation = _geolocationRepository.getLastSelectedLocation();
    final cityToFetch = lastLocation ?? AppConfigs.defaultCity;
    TLogger.debug(
      'Last selected location: $lastLocation, will fetch: $cityToFetch',
    );

    // Delegate to FetchWeatherByCityEvent which handles everything
    add(FetchWeatherByCityEvent(cityToFetch));
  }

  /// Handles the [FetchWeatherByCityEvent].
  ///
  /// Standardizes fetching by first resolving the [stationName] to geographic coordinates
  /// via [GeolocationRepository], then dispatching a [FetchWeatherByCoordinatesEvent].
  Future<void> _onFetchWeatherByCity(
    FetchWeatherByCityEvent event,
    Emitter<WeatherState> emit,
  ) async {
    TLogger.info(
      'Event: FetchWeatherByCityEvent converting to coords for: ${event.stationName}',
    );
    emit(WeatherLoading(cityName: event.stationName));
    TLogger.debug('State: WeatherLoading');

    try {
      // 1. Search for location coordinates using Geolocation API
      final locations = await _geolocationRepository.searchLocations(
        event.stationName,
      );

      if (locations.isEmpty) {
        throw ApiException(
          message: 'Location not found: ${event.stationName}',
          errorType: 'not_found',
        );
      }

      // Pick the first/best match
      final bestMatch = locations.first;
      TLogger.debug(
        'Resolved ${event.stationName} to ${bestMatch.lat}, ${bestMatch.lon}',
      );

      // 2. Delegate to coordinate fetch event
      // This ensures we always use coordinate-based fetching
      add(
        FetchWeatherByCoordinatesEvent(
          latitude: bestMatch.lat,
          longitude: bestMatch.lon,
          location: bestMatch,
        ),
      );
    } on ApiException catch (e) {
      TLogger.error('API Error resolving location', error: e.userMessage);
      emit(
        WeatherError(
          e.userMessage,
          errorType: e.errorType,
          previousWeather: _currentWeather,
        ),
      );
      emit(WeatherErrorActionState(e.userMessage));
    } catch (e, stackTrace) {
      final msg = 'An unexpected error occurred: ${e.toString()}';
      TLogger.error('Unexpected error', error: e, stackTrace: stackTrace);
      emit(WeatherError(msg, previousWeather: _currentWeather));
      emit(WeatherErrorActionState(msg));
    }
  }

  /// Handles the [FetchWeatherByCoordinatesEvent].
  ///
  /// Fetches weather data using [WeatherRepository] and updates local state.
  /// Also persists the location to history and "last selected" storage.
  Future<void> _onFetchWeatherByCoordinates(
    FetchWeatherByCoordinatesEvent event,
    Emitter<WeatherState> emit,
  ) async {
    TLogger.info(
      'Event: FetchWeatherByCoordinatesEvent (${event.latitude}, ${event.longitude})',
    );
    emit(WeatherLoading(cityName: event.location?.name));
    TLogger.debug('State: WeatherLoading');

    try {
      final weather = await _weatherRepository.getWeatherByCoordinates(
        lat: event.latitude,
        lon: event.longitude,
      );
      TLogger.debug('Fetched weather for coords: ${weather.stationName}');

      // Store the searched name in geolocationName, keep API name in stationName
      if (event.location != null) {
        _currentWeather = weather.copyWith(
          geolocationName: event.location!.name,
        );
        TLogger.debug('Set geolocationName: ${event.location!.name}');
      } else {
        _currentWeather = weather;
      }

      emit(WeatherLoaded(_currentWeather!));
      TLogger.info('State: WeatherLoaded for ${_currentWeather!.stationName}');

      // Save to persistence - use location name (user-selected) if available
      if (event.location != null && event.location!.name != null) {
        await _geolocationRepository.saveLastSelectedLocation(
          event.location!.name!,
        );
        TLogger.debug(
          'Saved location name to persistence: ${event.location!.name}',
        );
        await _geolocationRepository.addToHistory(event.location!);
      } else if (weather.stationName != null) {
        await _geolocationRepository.saveLastSelectedLocation(
          weather.stationName!,
        );
        TLogger.debug('Saved city to persistence: ${weather.stationName}');
      }
    } on ApiException catch (e) {
      TLogger.error('API Error fetching by coordinates', error: e.userMessage);
      emit(
        WeatherError(
          e.userMessage,
          errorType: e.errorType,
          previousWeather: _currentWeather,
        ),
      );
      emit(WeatherErrorActionState(e.userMessage));
    } catch (e, stackTrace) {
      final msg = 'An unexpected error occurred: ${e.toString()}';
      TLogger.error('Unexpected error', error: e, stackTrace: stackTrace);
      emit(WeatherError(msg, previousWeather: _currentWeather));
      emit(WeatherErrorActionState(msg));
    }
  }

  /// Handles the [RefreshWeatherEvent] to fetch fresh data for the currently displayed location.
  Future<void> _onRefreshWeather(
    RefreshWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    TLogger.info('Event: RefreshWeatherEvent');

    if (_currentWeather == null) {
      TLogger.warning('Refresh failed: No weather data to refresh');
      emit(WeatherError('No weather data to refresh'));
      emit(WeatherErrorActionState('No weather data to refresh'));
      return;
    }

    TLogger.debug('Refreshing weather for: ${_currentWeather!.stationName}');
    emit(WeatherRefreshing(_currentWeather!));
    TLogger.debug('State: WeatherRefreshing');

    try {
      WeatherModel weather;
      // Prefer coordinates for refresh if available (they should be)
      if (_currentWeather!.latitude != null &&
          _currentWeather!.longitude != null) {
        TLogger.debug(
          'Refeshing via coordinates: ${_currentWeather!.latitude}, ${_currentWeather!.longitude}',
        );
        weather = await _weatherRepository.getWeatherByCoordinates(
          lat: _currentWeather!.latitude!,
          lon: _currentWeather!.longitude!,
          forceRefresh: true,
        );
      } else {
        // Fallback to name-based refresh (should be rare/legacy)
        TLogger.debug(
          'Refeshing via name (fallback): ${_currentWeather!.stationName}',
        );
        weather = await _weatherRepository.getWeatherByCity(
          _currentWeather!.stationName!,
          forceRefresh: true,
        );
      }

      TLogger.debug(
        'Refresh successful: ${weather.stationName}, temp: ${weather.temperature}°',
      );

      // Persist geolocationName (user selected name) if it exists
      if (_currentWeather!.geolocationName != null) {
        _currentWeather = weather.copyWith(
          geolocationName: _currentWeather!.geolocationName,
        );
      } else {
        _currentWeather = weather;
      }

      emit(
        WeatherLoaded(_currentWeather!, refreshStatus: RefreshStatus.success),
      );
      TLogger.info('State: WeatherLoaded (refresh success)');

      await Future.delayed(const Duration(milliseconds: 1500));
      emit(WeatherLoaded(_currentWeather!, refreshStatus: RefreshStatus.none));
    } on ApiException catch (e) {
      TLogger.error('Refresh API error', error: e.userMessage);
      emit(WeatherErrorActionState(e.userMessage));
      emit(WeatherLoaded(_currentWeather!, refreshStatus: RefreshStatus.error));

      await Future.delayed(const Duration(seconds: 2));
      emit(WeatherLoaded(_currentWeather!, refreshStatus: RefreshStatus.none));
    } catch (e, stackTrace) {
      final msg = 'Failed to refresh: ${e.toString()}';
      TLogger.error(
        'Refresh unexpected error',
        error: e,
        stackTrace: stackTrace,
      );
      emit(WeatherErrorActionState(msg));
      emit(WeatherLoaded(_currentWeather!, refreshStatus: RefreshStatus.error));

      await Future.delayed(const Duration(seconds: 2));
      emit(WeatherLoaded(_currentWeather!, refreshStatus: RefreshStatus.none));
    }
  }

  /// Handles the [SearchLocationsEvent] to find locations matching the search query.
  ///
  /// This operation is debounced to avoid excessive API calls while typing.
  Future<void> _onSearchLocations(
    SearchLocationsEvent event,
    Emitter<WeatherState> emit,
  ) async {
    TLogger.info('Event: SearchLocationsEvent query="${event.query}"');

    if (event.query.isEmpty) {
      TLogger.debug('Empty query, returning empty results');
      emit(LocationSearchLoaded([]));
      return;
    }

    emit(LocationSearchLoading());
    TLogger.debug('State: LocationSearchLoading');

    try {
      final locations = await _geolocationRepository.searchLocations(
        event.query,
      );
      TLogger.debug('Found ${locations.length} locations');
      emit(LocationSearchLoaded(locations));
      TLogger.debug('State: LocationSearchLoaded');
    } on ApiException catch (e) {
      TLogger.error('Search API error', error: e.userMessage);
      emit(WeatherErrorActionState(e.userMessage));
    } catch (e, stackTrace) {
      TLogger.error(
        'Search unexpected error',
        error: e,
        stackTrace: stackTrace,
      );
      emit(
        WeatherErrorActionState('Failed to search locations: ${e.toString()}'),
      );
    }
  }

  /// Loads the saved search history.
  Future<void> _onLoadSearchHistory(
    LoadSearchHistoryEvent event,
    Emitter<WeatherState> emit,
  ) async {
    TLogger.info('Event: LoadSearchHistoryEvent');
    try {
      final history = await _geolocationRepository.getSearchHistory();
      TLogger.debug('Loaded ${history.length} history items');
      emit(SearchHistoryLoaded(history));
      TLogger.debug('State: SearchHistoryLoaded');
    } catch (e, stackTrace) {
      TLogger.error('Failed to load history', error: e, stackTrace: stackTrace);
      emit(SearchHistoryLoaded([]));
    }
  }

  /// Removes a location from search history and clears its cache.
  Future<void> _onRemoveFromHistory(
    RemoveFromHistoryEvent event,
    Emitter<WeatherState> emit,
  ) async {
    final locationName = event.location.name ?? 'Unknown';
    TLogger.info('Event: RemoveFromHistoryEvent for $locationName');
    try {
      final removed = await _geolocationRepository.removeFromHistory(
        event.location,
      );

      if (removed) {
        TLogger.debug('Removed from history: $locationName');

        // Clear weather cache for this location
        if (event.location.name != null) {
          await _weatherRepository.clearWeatherCache(event.location.name!);
          TLogger.debug('Cleared weather cache for: $locationName');
        }

        // Check if this was the currently selected location
        final lastLocation = _geolocationRepository.getLastSelectedLocation();
        if (lastLocation != null &&
            lastLocation.toLowerCase() == locationName.toLowerCase()) {
          TLogger.debug(
            'Removed location was current selection, clearing persistence',
          );
          await _geolocationRepository.clearLastSelectedLocation();
          _currentWeather = null;
        }

        // Get updated history
        final updatedHistory = await _geolocationRepository.getSearchHistory();
        TLogger.debug('Updated history count: ${updatedHistory.length}');

        // If no history remains and current weather is cleared, prompt for location
        if (updatedHistory.isEmpty && _currentWeather == null) {
          TLogger.info('State: NoLocationSelected');
          emit(NoLocationSelected());
        } else {
          emit(SearchHistoryLoaded(updatedHistory));
        }
      } else {
        TLogger.warning('Location not found in history');
      }
    } catch (e, stackTrace) {
      TLogger.error(
        'Error removing from history',
        error: e,
        stackTrace: stackTrace,
      );
      add(LoadSearchHistoryEvent());
    }
  }

  /// Returns the default city name defined in [AppConfigs].
  static String get defaultCity => AppConfigs.defaultCity;

  /// Returns the name of the last selected location from storage.
  String? get lastSelectedCity =>
      _geolocationRepository.getLastSelectedLocation();

  /// Returns the currently loaded [WeatherModel], if any.
  WeatherModel? get currentWeather => _currentWeather;
}
