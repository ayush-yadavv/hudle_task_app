import 'package:flutter_test/flutter_test.dart';
import 'package:hudle_task_app/data/datasources/weather/weather_local_data_source.dart';
import 'package:hudle_task_app/data/datasources/weather/weather_remote_data_source.dart';
import 'package:hudle_task_app/data/repository/weather_repository.dart';
import 'package:hudle_task_app/domain/models/weather_data_model/weather_model.dart';
import 'package:hudle_task_app/utils/exceptions/api_exception.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements IWeatherRemoteDataSource {}

class MockLocalDataSource extends Mock implements IWeatherLocalDataSource {}

void main() {
  late WeatherRepository weatherRepository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late WeatherModel tWeather;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(WeatherModel(id: 0, lastFetched: DateTime.now()));
  });

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();

    when(() => mockLocalDataSource.init()).thenAnswer((_) async {});

    weatherRepository = WeatherRepository(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );

    tWeather = WeatherModel(
      id: 1,
      stationName: 'London',
      temperature: 20.0,
      description: 'Sunny',
      iconCode: '01d',
      humidity: 50,
      windSpeed: 5.0,
      latitude: 51.5074,
      longitude: -0.1278,
      timestamp: 1600000000,
      feelsLike: 18.0,
      pressure: 1012,
      minTemp: 15.0,
      maxTemp: 22.0,
      lastFetched: DateTime.now(),
    );
  });

  group('WeatherRepository', () {
    group('getWeatherByCity', () {
      test('returns cached weather if valid and not force refresh', () async {
        // Arrange
        when(
          () => mockLocalDataSource.getLastWeather('London'),
        ).thenAnswer((_) async => tWeather);

        // Act
        final result = await weatherRepository.getWeatherByCity('London');

        // Assert
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, tWeather);
      });

      test('fetches from Remote if cache expired or force refresh', () async {
        // Arrange
        when(() => mockLocalDataSource.getLastWeather('London')).thenAnswer(
          (_) async => tWeather.copyWith(
            lastFetched: DateTime.now().subtract(const Duration(hours: 1)),
          ),
        );

        when(
          () => mockRemoteDataSource.getWeatherByCity('London'),
        ).thenAnswer((_) async => tWeather);

        when(
          () => mockLocalDataSource.cacheWeather(any(), any()),
        ).thenAnswer((_) async {});

        // Act
        final result = await weatherRepository.getWeatherByCity(
          'London',
          forceRefresh: true,
        );

        // Assert
        verify(() => mockRemoteDataSource.getWeatherByCity('London')).called(1);
        verify(
          () => mockLocalDataSource.cacheWeather('London', any()),
        ).called(1);
        expect(result, tWeather);
      });

      test('returns expired cache on offline error if cache exists', () async {
        // Arrange
        final expiredWeather = tWeather.copyWith(
          lastFetched: DateTime.now().subtract(const Duration(hours: 1)),
        );

        when(
          () => mockLocalDataSource.getLastWeather('London'),
        ).thenAnswer((_) async => expiredWeather);

        when(() => mockRemoteDataSource.getWeatherByCity('London')).thenThrow(
          ApiException(message: 'No internet', errorType: 'no_internet'),
        );

        // Act
        final result = await weatherRepository.getWeatherByCity(
          'London',
          forceRefresh: true,
        );

        // Assert
        expect(result, expiredWeather);
      });

      test('throws ApiException on API failure when no cache', () async {
        // Arrange
        when(
          () => mockLocalDataSource.getLastWeather('London'),
        ).thenAnswer((_) async => null);

        when(() => mockRemoteDataSource.getWeatherByCity('London')).thenThrow(
          ApiException(message: 'Server error', errorType: 'server_error'),
        );

        // Act & Assert
        expect(
          () => weatherRepository.getWeatherByCity('London'),
          throwsA(isA<ApiException>()),
        );
      });
    });

    group('getWeatherByCoordinates', () {
      test('fetches from API and saves to cache', () async {
        when(
          () => mockLocalDataSource.getLastWeather(any()),
        ).thenAnswer((_) async => null);

        when(
          () => mockRemoteDataSource.getWeatherByCoordinates(51.5, -0.12),
        ).thenAnswer((_) async => tWeather);

        when(
          () => mockLocalDataSource.cacheWeather(any(), any()),
        ).thenAnswer((_) async {});

        final result = await weatherRepository.getWeatherByCoordinates(
          lat: 51.5,
          lon: -0.12,
        );

        final expectedKey =
            '${51.50.toStringAsFixed(2)}_${(-0.12).toStringAsFixed(2)}';

        verify(
          () => mockLocalDataSource.cacheWeather(expectedKey, any()),
        ).called(1);
        expect(result, tWeather);
      });
    });

    group('Cache Management', () {
      test('clearWeatherCache deletes specific key', () async {
        when(
          () => mockLocalDataSource.clearWeatherCache('London'),
        ).thenAnswer((_) async {});

        await weatherRepository.clearWeatherCache('London');
        verify(() => mockLocalDataSource.clearWeatherCache('London')).called(1);
      });

      test('clearAllCache deleted all keys', () async {
        when(
          () => mockLocalDataSource.clearAllCache(),
        ).thenAnswer((_) async {});

        await weatherRepository.clearAllCache();
        verify(() => mockLocalDataSource.clearAllCache()).called(1);
      });
    });
  });
}
