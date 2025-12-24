import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hudle_task_app/data/repository/weather_repository.dart';
import 'package:hudle_task_app/domain/models/weather_model.dart';
import 'package:hudle_task_app/utils/dio/dio_client.dart';
import 'package:hudle_task_app/utils/exceptions/api_exception.dart';
import 'package:mocktail/mocktail.dart';

class MockDioClient extends Mock implements DioClient {}

class FakeWeatherBox extends Fake implements Box<WeatherModel> {
  final Map<dynamic, WeatherModel> _data = {};

  @override
  bool get isOpen => true;

  @override
  Iterable<WeatherModel> get values => _data.values;

  @override
  int get length => _data.length;

  @override
  WeatherModel? get(key, {WeatherModel? defaultValue}) {
    return _data[key] ?? defaultValue;
  }

  @override
  Future<void> put(key, WeatherModel value) async {
    _data[key] = value;
  }

  @override
  Future<void> delete(key) async {
    _data.remove(key);
  }

  @override
  Future<int> clear() async {
    final count = _data.length;
    _data.clear();
    return count;
  }

  @override
  Future<void> close() async {}
}

void main() {
  late WeatherRepository weatherRepository;
  late MockDioClient mockDioClient;
  late FakeWeatherBox fakeWeatherBox;
  late WeatherModel tWeather;

  final Map<String, dynamic> tWeatherData = {
    'weather': [
      {'id': 800, 'main': 'Clear', 'description': 'clear sky', 'icon': '01d'},
    ],
    'main': {
      'temp': 293.15,
      'feels_like': 293.15,
      'temp_min': 293.15,
      'temp_max': 293.15,
      'pressure': 1013,
      'humidity': 53,
    },
    'visibility': 10000,
    'wind': {'speed': 3.6, 'deg': 160},
    'clouds': {'all': 0},
    'dt': 1600000000,
    'sys': {
      'type': 1,
      'id': 5122,
      'country': 'GB',
      'sunrise': 1600000000,
      'sunset': 1600000000,
    },
    'timezone': 3600,
    'id': 2643743,
    'name': 'London',
    'cod': 200,
  };

  final Map<String, dynamic> tForecastData = {
    'list': [
      {
        'main': {'temp': 20.0},
      },
      {
        'main': {'temp': 22.0},
      },
      {
        'main': {'temp': 18.0},
      },
    ],
  };

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockDioClient = MockDioClient();
    fakeWeatherBox = FakeWeatherBox();
    weatherRepository = WeatherRepository(
      dioClient: mockDioClient,
      apiKey: 'test_key',
    );
    weatherRepository.weatherBox = fakeWeatherBox;

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
        await fakeWeatherBox.put('london', tWeather);

        // Act
        final result = await weatherRepository.getWeatherByCity('London');

        // Assert
        verifyZeroInteractions(mockDioClient);
        // Compare essential fields or object reference
        expect(result.stationName, tWeather.stationName);
      });

      test('fetches from API if cache expired or force refresh', () async {
        // Arrange
        when(
          () => mockDioClient.get(
            '/weather',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((invocation) async {
          return tWeatherData;
        });

        when(
          () => mockDioClient.get(
            '/forecast',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((invocation) async {
          return tForecastData;
        });

        // Act
        final result = await weatherRepository.getWeatherByCity(
          'London',
          forceRefresh: true,
        );

        // Assert
        verify(
          () => mockDioClient.get(
            '/weather',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).called(1);

        expect(result.stationName, 'London');
        expect(fakeWeatherBox._data.containsKey('london'), true);
      });

      test('returns expired cache on offline error if cache exists', () async {
        // Arrange
        final expiredWeather = tWeather.copyWith(
          lastFetched: DateTime.now().subtract(const Duration(hours: 1)),
        );
        await fakeWeatherBox.put('london', expiredWeather);

        when(
          () => mockDioClient.get(
            '/weather',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(requestOptions: RequestOptions(path: '/weather')),
        );

        // Act
        final result = await weatherRepository.getWeatherByCity(
          'London',
          forceRefresh: true,
        );

        // Assert
        expect(result.stationName, expiredWeather.stationName);
      });

      test('throws ApiException on API failure when no cache', () async {
        // Arrange
        // Empty box
        when(
          () => mockDioClient.get(
            '/weather',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(requestOptions: RequestOptions(path: '/weather')),
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
          () => mockDioClient.get(
            '/weather',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((invocation) async {
          return tWeatherData;
        });

        when(
          () => mockDioClient.get(
            '/forecast',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((invocation) async {
          return tForecastData;
        });

        final result = await weatherRepository.getWeatherByCoordinates(
          lat: 51.5,
          lon: -0.12,
        );

        final expectedKey =
            '${51.50.toStringAsFixed(2)}_${(-0.12).toStringAsFixed(2)}';

        expect(result.stationName, 'London');
        expect(fakeWeatherBox._data.containsKey(expectedKey), true);
      });
    });

    group('Cache Management', () {
      test('clearWeatherCache deletes specific key', () async {
        await fakeWeatherBox.put('london', tWeather);
        await weatherRepository.clearWeatherCache('London');
        expect(fakeWeatherBox._data.containsKey('london'), false);
      });

      test('clearAllCache deleted all keys', () async {
        await fakeWeatherBox.put('london', tWeather);
        await weatherRepository.clearAllCache();
        expect(fakeWeatherBox._data.isEmpty, true);
      });
    });
  });
}
