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

  group('WeatherBloc - Fetch by City', () {
    blocTest<WeatherBloc, WeatherState>(
      'emits [WeatherLoading, WeatherLoading, WeatherLoaded] when city is found and weather fetched',
      build: () {
        when(
          () => mockGeolocationRepository.searchLocations('London'),
        ).thenAnswer((invocation) async {
          print(
            'Test: searchLocations called with ${invocation.positionalArguments}',
          );
          return [tLocation];
        });
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
          ),
        ).thenAnswer((invocation) async {
          print(
            'Test: getWeatherByCoordinates called with: ${invocation.namedArguments}',
          );
          return tWeather;
        });
        when(
          () => mockGeolocationRepository.saveLastSelectedLocation(any()),
        ).thenAnswer((_) async {});
        when(
          () => mockGeolocationRepository.addToHistory(any()),
        ).thenAnswer((_) async {});
        return weatherBloc;
      },
      act: (bloc) => bloc.add(FetchWeatherByCityEvent('London')),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        isA<WeatherLoading>(),
        isA<WeatherLoading>(),
        isA<WeatherLoaded>(),
      ],
      verify: (_) {
        verify(
          () => mockGeolocationRepository.searchLocations(any()),
        ).called(1);
      },
    );

    blocTest<WeatherBloc, WeatherState>(
      'emits [WeatherLoading, WeatherError, WeatherErrorActionState] when location not found',
      build: () {
        when(
          () => mockGeolocationRepository.searchLocations(any()),
        ).thenAnswer((_) async => []);
        when(
          () => mockGeolocationRepository.getLastSelectedLocation(),
        ).thenReturn(null);
        return weatherBloc;
      },
      act: (bloc) => bloc.add(FetchWeatherByCityEvent('Unknown')),
      expect: () => [
        isA<WeatherLoading>(),
        isA<WeatherError>(),
        isA<WeatherErrorActionState>(),
      ],
    );
  });
}
