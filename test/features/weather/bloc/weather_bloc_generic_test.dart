import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hudle_task_app/domain/models/location_model.dart';
import 'package:hudle_task_app/domain/models/weather_model.dart';
import 'package:hudle_task_app/features/weather/bloc/weather_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'test_helpers.dart';

void main() {
  late WeatherBloc weatherBloc;
  late MockWeatherRepository mockWeatherRepository;
  late MockGeolocationRepository mockGeolocationRepository;

  setUpAll(() {
    registerCommonFallbacks();
  });

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

  group('WeatherBloc - Generic Events', () {
    test('initial state is WeatherInitial', () {
      expect(weatherBloc.state, isA<WeatherInitial>());
    });

    group('LoadInitialWeatherEvent', () {
      blocTest<WeatherBloc, WeatherState>(
        'fetches default city when no last selected location exists',
        build: () {
          when(
            () => mockGeolocationRepository.getLastSelectedLocation(),
          ).thenReturn(null);
          when(
            () => mockGeolocationRepository.searchLocations(any()),
          ).thenAnswer((_) async => [tLocation]);
          when(
            () => mockWeatherRepository.getWeatherByCoordinates(
              lat: any(named: 'lat'),
              lon: any(named: 'lon'),
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
        act: (bloc) => bloc.add(LoadInitialWeatherEvent()),
        verify: (_) {
          // We expect the default city logic to trigger a FetchWeatherByCityEvent
          // which in turn calls searchLocations.
          // We can verify this happened.
          verify(
            () => mockGeolocationRepository.searchLocations(any()),
          ).called(1);
        },
      );
    });

    group('FetchWeatherByCoordinatesEvent', () {
      blocTest<WeatherBloc, WeatherState>(
        'emits [WeatherLoading, WeatherLoaded] when weather is fetched successfully',
        build: () {
          when(
            () => mockWeatherRepository.getWeatherByCoordinates(
              lat: any(named: 'lat'),
              lon: any(named: 'lon'),
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
        act: (bloc) => bloc.add(
          FetchWeatherByCoordinatesEvent(
            latitude: 51.5,
            longitude: -0.1,
            location: tLocation,
          ),
        ),
        expect: () => [isA<WeatherLoading>(), isA<WeatherLoaded>()],
      );
    });
  });
}
