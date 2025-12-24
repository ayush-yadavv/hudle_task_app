import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:hudle_task_app/data/repository/weather_repository.dart';
import 'package:hudle_task_app/domain/models/location_model.dart';
import 'package:hudle_task_app/domain/models/weather_model.dart';
import 'package:hudle_task_app/utils/exceptions/api_exception.dart';
import 'package:meta/meta.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository _weatherRepository;
  WeatherModel? _currentWeather;

  WeatherBloc({WeatherRepository? weatherRepository})
    : _weatherRepository = weatherRepository ?? WeatherRepository(),
      super(WeatherInitial()) {
    on<FetchWeatherByCityEvent>(_onFetchWeatherByCity);
    on<FetchWeatherByCoordinatesEvent>(_onFetchWeatherByCoordinates);
    on<RefreshWeatherEvent>(_onRefreshWeather);
    on<SearchLocationsEvent>(_onSearchLocations);
    on<LoadSearchHistoryEvent>(_onLoadSearchHistory);
  }

  /// Add a location to search history (Hive)
  Future<void> _addToHistory(LocationModel location) async {
    final box = await Hive.openBox<LocationModel>('search_history');

    // Check for duplicates
    final items = box.values.toList();
    final existingIndex = items.indexOf(location);

    if (existingIndex != -1) {
      await box.deleteAt(existingIndex);
    }

    // Update lastFetched and add to end (most recent)
    final updatedLocation = LocationModel(
      name: location.name,
      country: location.country,
      state: location.state,
      lat: location.lat,
      lon: location.lon,
      lastFetched: DateTime.now(),
    );

    await box.add(updatedLocation);

    // Limit to 10 entries
    if (box.length > 10) {
      await box.deleteAt(0);
    }
  }

  /// Handle fetching weather by city name
  Future<void> _onFetchWeatherByCity(
    FetchWeatherByCityEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());

    try {
      final weather = await _weatherRepository.getWeatherByCity(event.cityName);
      _currentWeather = weather;
      emit(WeatherLoaded(weather));
    } on ApiException catch (e) {
      emit(WeatherError(e.userMessage, errorType: e.errorType));
      emit(WeatherErrorActionState(e.userMessage));
    } catch (e) {
      final msg = 'An unexpected error occurred: ${e.toString()}';
      emit(WeatherError(msg));
      emit(WeatherErrorActionState(msg));
    }
  }

  /// Handle fetching weather by coordinates
  Future<void> _onFetchWeatherByCoordinates(
    FetchWeatherByCoordinatesEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());

    try {
      final weather = await _weatherRepository.getWeatherByCoordinates(
        lat: event.latitude,
        lon: event.longitude,
      );
      _currentWeather = weather;
      emit(WeatherLoaded(weather));

      // If we have a location from the event, save it to history
      if (event.location != null) {
        await _addToHistory(event.location!);
      }
    } on ApiException catch (e) {
      emit(WeatherError(e.userMessage, errorType: e.errorType));
      emit(WeatherErrorActionState(e.userMessage));
    } catch (e) {
      final msg = 'An unexpected error occurred: ${e.toString()}';
      emit(WeatherError(msg));
      emit(WeatherErrorActionState(msg));
    }
  }

  /// Handle refreshing current weather data
  Future<void> _onRefreshWeather(
    RefreshWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    if (_currentWeather == null) {
      emit(WeatherError('No weather data to refresh'));
      emit(WeatherErrorActionState('No weather data to refresh'));
      return;
    }

    // Emit refreshing state - keeps data visible with inline loading indicator
    emit(WeatherRefreshing(_currentWeather!));

    try {
      final weather = await _weatherRepository.getWeatherByCity(
        _currentWeather!.cityName!,
      );
      _currentWeather = weather;
      emit(WeatherLoaded(weather));
    } on ApiException catch (e) {
      emit(WeatherErrorActionState(e.userMessage));
      // Restore previous data on error
      emit(WeatherLoaded(_currentWeather!));
    } catch (e) {
      final msg = 'Failed to refresh: ${e.toString()}';
      emit(WeatherErrorActionState(msg));
      // Restore previous data on error
      emit(WeatherLoaded(_currentWeather!));
    }
  }

  /// Handle searching for locations
  Future<void> _onSearchLocations(
    SearchLocationsEvent event,
    Emitter<WeatherState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(LocationSearchLoaded([]));
      return;
    }

    emit(LocationSearchLoading());

    try {
      final locations = await _weatherRepository.searchLocations(event.query);
      emit(LocationSearchLoaded(locations));
    } on ApiException catch (e) {
      emit(WeatherErrorActionState(e.userMessage));
    } catch (e) {
      emit(
        WeatherErrorActionState('Failed to search locations: ${e.toString()}'),
      );
    }
  }

  /// Load search history from Hive
  Future<void> _onLoadSearchHistory(
    LoadSearchHistoryEvent event,
    Emitter<WeatherState> emit,
  ) async {
    try {
      final box = await Hive.openBox<LocationModel>('search_history');
      final history = box.values.toList().reversed.toList();
      emit(SearchHistoryLoaded(history));
    } catch (e) {
      emit(SearchHistoryLoaded([]));
    }
  }

  /// Get current weather data
  WeatherModel? get currentWeather => _currentWeather;
}
