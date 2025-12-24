import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hudle_task_app/data/repository/geolocation_repository.dart';
import 'package:hudle_task_app/domain/models/location_model.dart';
import 'package:hudle_task_app/utils/dio/dio_client.dart';
import 'package:hudle_task_app/utils/exceptions/api_exception.dart';
import 'package:mocktail/mocktail.dart';

class MockDioClient extends Mock implements DioClient {}

class FakeBox<T> extends Fake implements Box<T> {
  final Map<dynamic, T> _data = {};

  @override
  Iterable<T> get values => _data.values;

  @override
  int get length => _data.length;

  @override
  T? get(key, {T? defaultValue}) {
    return _data[key] ?? defaultValue;
  }

  @override
  Future<void> put(key, T value) async {
    _data[key] = value;
  }

  @override
  Future<int> add(T value) async {
    _data[_data.length] = value;
    return _data.length - 1;
  }

  @override
  Future<void> delete(key) async {
    _data.remove(key);
  }

  @override
  Future<void> deleteAt(int index) async {
    _data.remove(index);
  }

  @override
  Future<int> clear() async {
    final count = _data.length;
    _data.clear();
    return count;
  }
}

void main() {
  late GeolocationRepository geolocationRepository;
  late MockDioClient mockDioClient;
  late FakeBox<String> fakePreferencesBox;
  late FakeBox<LocationModel> fakeHistoryBox;

  final tLocation = LocationModel(
    name: 'London',
    lat: 51.5,
    lon: -0.1,
    country: 'UK',
    state: 'England',
    id: '1',
  );

  final tSearchResponse = {
    'results': [
      {
        'name': 'London',
        'country': 'UK',
        'admin1': 'England',
        'latitude': 51.5,
        'longitude': -0.1,
        'id': 1,
      },
    ],
  };

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockDioClient = MockDioClient();
    fakePreferencesBox = FakeBox<String>();
    fakeHistoryBox = FakeBox<LocationModel>();

    geolocationRepository = GeolocationRepository(dioClient: mockDioClient);
    geolocationRepository.preferencesBox = fakePreferencesBox;
    geolocationRepository.historyBox = fakeHistoryBox;
  });

  group('GeolocationRepository', () {
    group('Preferences', () {
      test('saveLastSelectedLocation puts value in box', () async {
        await geolocationRepository.saveLastSelectedLocation('London');
        expect(fakePreferencesBox._data['last_selected_city'], 'London');
      });

      test('getLastSelectedLocation gets value from box', () {
        fakePreferencesBox._data['last_selected_city'] = 'London';

        final result = geolocationRepository.getLastSelectedLocation();

        expect(result, 'London');
      });

      test('clearLastSelectedLocation deletes from box', () async {
        fakePreferencesBox._data['last_selected_city'] = 'London';

        await geolocationRepository.clearLastSelectedLocation();

        expect(
          fakePreferencesBox._data.containsKey('last_selected_city'),
          false,
        );
      });
    });

    group('Search History', () {
      test('getSearchHistory returns reversed values', () async {
        await fakeHistoryBox.add(tLocation);

        final result = await geolocationRepository.getSearchHistory();

        expect(result.length, 1);
        expect(result.first, tLocation);
      });

      test('addToHistory adds item and handles limit', () async {
        await geolocationRepository.addToHistory(tLocation);

        expect(fakeHistoryBox.values.length, 1);
        expect(fakeHistoryBox.values.first, tLocation);
      });
    });

    group('searchLocations', () {
      test('returns list of locations on success', () async {
        when(
          () => mockDioClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => tSearchResponse);

        final result = await geolocationRepository.searchLocations('London');

        expect(result.length, 1);
        expect(result.first.name, 'London');
      });

      test('returns empty list if response is null', () async {
        when(
          () => mockDioClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => null);

        final result = await geolocationRepository.searchLocations('London');

        expect(result, isEmpty);
      });

      test('throws ApiException on error', () async {
        when(
          () => mockDioClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(requestOptions: RequestOptions(path: '/search')),
        );

        expect(
          () => geolocationRepository.searchLocations('London'),
          throwsA(isA<ApiException>()),
        );
      });
    });
  });
}
