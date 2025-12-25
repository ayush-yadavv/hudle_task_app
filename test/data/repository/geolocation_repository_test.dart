import 'package:flutter_test/flutter_test.dart';
import 'package:hudle_task_app/data/datasources/geo_location/geolocation_local_data_source.dart';
import 'package:hudle_task_app/data/datasources/geo_location/geolocation_remote_data_source.dart';
import 'package:hudle_task_app/data/repository/geolocation_repository.dart';
import 'package:hudle_task_app/domain/models/location_data_model/location_model.dart';
import 'package:hudle_task_app/utils/exceptions/api_exception.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock
    implements IGeolocationRemoteDataSource {}

class MockLocalDataSource extends Mock implements IGeolocationLocalDataSource {}

void main() {
  late GeolocationRepository geolocationRepository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;

  final tLocation = LocationModel(
    name: 'London',
    lat: 51.5,
    lon: -0.1,
    country: 'UK',
    state: 'England',
    id: '1',
  );

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();

    when(() => mockLocalDataSource.init()).thenAnswer((_) async {});

    geolocationRepository = GeolocationRepository(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('GeolocationRepository', () {
    group('Preferences', () {
      test('saveLastSelectedLocation calls local data source', () async {
        when(
          () => mockLocalDataSource.saveLastSelectedLocation('London'),
        ).thenAnswer((_) async {});

        await geolocationRepository.saveLastSelectedLocation('London');
        verify(
          () => mockLocalDataSource.saveLastSelectedLocation('London'),
        ).called(1);
      });

      test('getLastSelectedLocation gets value from local data source', () {
        when(
          () => mockLocalDataSource.getLastSelectedLocation(),
        ).thenReturn('London');
        final result = geolocationRepository.getLastSelectedLocation();
        expect(result, 'London');
      });

      test('clearLastSelectedLocation calls local data source', () async {
        when(
          () => mockLocalDataSource.clearLastSelectedLocation(),
        ).thenAnswer((_) async {});
        await geolocationRepository.clearLastSelectedLocation();
        verify(() => mockLocalDataSource.clearLastSelectedLocation()).called(1);
      });
    });

    group('Search History', () {
      test('getSearchHistory returns list from local data source', () async {
        when(
          () => mockLocalDataSource.getSearchHistory(),
        ).thenAnswer((_) async => [tLocation]);

        final result = await geolocationRepository.getSearchHistory();

        expect(result.length, 1);
        expect(result.first, tLocation);
      });

      test('addToHistory calls local data source', () async {
        when(
          () => mockLocalDataSource.addToHistory(tLocation),
        ).thenAnswer((_) async {});

        await geolocationRepository.addToHistory(tLocation);
        verify(() => mockLocalDataSource.addToHistory(tLocation)).called(1);
      });
    });

    group('searchLocations', () {
      test('delegates to remote data source', () async {
        when(
          () => mockRemoteDataSource.searchLocations('London'),
        ).thenAnswer((_) async => [tLocation]);

        final result = await geolocationRepository.searchLocations('London');

        expect(result.length, 1);
        expect(result.first, tLocation);
        verify(() => mockRemoteDataSource.searchLocations('London')).called(1);
      });

      test('propagates errors from remote data source', () async {
        when(
          () => mockRemoteDataSource.searchLocations('London'),
        ).thenThrow(ApiException(message: 'Error', errorType: 'error'));

        expect(
          () => geolocationRepository.searchLocations('London'),
          throwsA(isA<ApiException>()),
        );
      });
    });
  });
}
