import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hudle_task_app/domain/models/location_model.dart';
import 'package:hudle_task_app/domain/models/weather_model.dart';
import 'package:hudle_task_app/features/weather/bloc/weather_bloc.dart';
import 'package:hudle_task_app/utils/constants/app_enums.dart';
import 'package:mocktail/mocktail.dart';

import 'test_helpers.dart';

void main() {
  late WeatherBloc weatherBloc;
  late MockWeatherRepository mockWeatherRepository;
  late MockGeolocationRepository mockGeolocationRepository;

  final tLocation = LocationModel(
    name: 'London',
    lat: 51.5074,
    lon: -0.1278,
    country: 'UK',
    state: 'England',
    id: '1',
  );

  final tWeather = WeatherModel(
    id: 1,
    stationName: 'London',
    temperature: 20.0,
    description: 'Sunny',
    iconCode: '01d',
    humidity: 50,
    windSpeed: 5.0,
    latitude: 51.5074,
    longitude: -0.1278,
    timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    feelsLike: 18.0,
    pressure: 1012,
    minTemp: 15.0,
    maxTemp: 22.0,
    lastFetched: DateTime.now(),
  );

  setUpAll(() {
    registerCommonFallbacks();
  });

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    mockGeolocationRepository = MockGeolocationRepository();
    weatherBloc = WeatherBloc(
      weatherRepository: mockWeatherRepository,
      geolocationRepository: mockGeolocationRepository,
    );
  });

  tearDown(() {
    weatherBloc.close();
  });

  group('WeatherBloc - Management Events', () {
    group('RefreshWeatherEvent', () {
      blocTest<WeatherBloc, WeatherState>(
        'emits [WeatherRefreshing, WeatherLoaded, WeatherLoaded] when refresh succeeds',
        build: () {
          when(
            () => mockWeatherRepository.getWeatherByCoordinates(
              lat: any(named: 'lat'),
              lon: any(named: 'lon'),
            ),
          ).thenAnswer((_) async => tWeather);
          when(
            () => mockWeatherRepository.getWeatherByCoordinates(
              lat: any(named: 'lat'),
              lon: any(named: 'lon'),
              forceRefresh: true,
            ),
          ).thenAnswer((_) async => tWeather);
          when(
            () => mockGeolocationRepository.saveLastSelectedLocation(any()),
          ).thenAnswer((_) async {});
          when(
            () => mockGeolocationRepository.addToHistory(any()),
          ).thenAnswer((_) async {});

          return weatherBloc;
        },
        act: (bloc) async {
          // Pre-load data
          bloc.add(
            FetchWeatherByCoordinatesEvent(
              latitude: 51.5,
              longitude: -0.1,
              location: tLocation,
            ),
          );
          // wait for initial load to finish
          await Future.delayed(Duration(milliseconds: 100));
          // Refresh
          bloc.add(RefreshWeatherEvent());
        },
        wait: const Duration(milliseconds: 2000),
        skip: 2, // Skip initial loading/loaded events
        expect: () => [
          isA<WeatherRefreshing>(),
          isA<WeatherLoaded>().having(
            (s) => s.refreshStatus,
            'status',
            RefreshStatus.success,
          ),
          isA<WeatherLoaded>().having(
            (s) => s.refreshStatus,
            'status',
            RefreshStatus.none,
          ),
        ],
      );
    });

    group('SearchLocationsEvent', () {
      blocTest<WeatherBloc, WeatherState>(
        'emits [LocationSearchLoading, LocationSearchLoaded] after debounce',
        build: () {
          when(
            () => mockGeolocationRepository.searchLocations(any()),
          ).thenAnswer((_) async => [tLocation]);
          return weatherBloc;
        },
        act: (bloc) => bloc.add(SearchLocationsEvent('London')),
        wait: const Duration(milliseconds: 600),
        expect: () => [
          isA<LocationSearchLoading>(),
          isA<LocationSearchLoaded>().having(
            (s) => s.locations.length,
            'length',
            1,
          ),
        ],
      );
    });

    group('History Events', () {
      final historyList = [tLocation];

      blocTest<WeatherBloc, WeatherState>(
        'LoadSearchHistoryEvent emits SearchHistoryLoaded',
        build: () {
          when(
            () => mockGeolocationRepository.getSearchHistory(),
          ).thenAnswer((_) async => historyList);
          return weatherBloc;
        },
        act: (bloc) => bloc.add(LoadSearchHistoryEvent()),
        expect: () => [
          isA<SearchHistoryLoaded>().having(
            (s) => s.history,
            'history',
            historyList,
          ),
        ],
      );

      blocTest<WeatherBloc, WeatherState>(
        'RemoveFromHistoryEvent removes item and reloads history',
        build: () {
          when(
            () => mockGeolocationRepository.removeFromHistory(any()),
          ).thenAnswer((_) async => true);
          when(
            () => mockGeolocationRepository.getSearchHistory(),
          ).thenAnswer((_) async => []); // Empty after remove
          when(
            () => mockGeolocationRepository.getLastSelectedLocation(),
          ).thenReturn('Paris'); // Not current
          when(
            () => mockWeatherRepository.clearWeatherCache(any()),
          ).thenAnswer((_) async {});

          return weatherBloc;
        },
        act: (bloc) => bloc.add(RemoveFromHistoryEvent(tLocation)),
        expect: () => [isA<NoLocationSelected>()],
      );
    });
  });
}
