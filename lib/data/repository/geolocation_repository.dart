import 'package:hudle_task_app/data/datasources/geo_location/geolocation_local_data_source.dart';
import 'package:hudle_task_app/data/datasources/geo_location/geolocation_remote_data_source.dart';
import 'package:hudle_task_app/domain/models/location_data_model/location_model.dart';
import 'package:hudle_task_app/domain/repository/i_geolocation_repository.dart';
import 'package:hudle_task_app/utils/logger/logger.dart';

/// Repository class responsible for location-related operations.
///
/// It manages:
/// - Searching for locations using [IGeolocationRemoteDataSource].
/// - Persisting selection and history using [IGeolocationLocalDataSource].
class GeolocationRepository implements IGeolocationRepository {
  final IGeolocationRemoteDataSource _remoteDataSource;
  final IGeolocationLocalDataSource _localDataSource;

  GeolocationRepository({
    required IGeolocationRemoteDataSource remoteDataSource,
    required IGeolocationLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  /// Initializes the local data source.
  @override
  Future<void> init() async {
    await _localDataSource.init();
    TLogger.info('GeolocationRepository initialized');
  }

  // ========== PREFERENCES ==========

  @override
  Future<void> saveLastSelectedLocation(String locationName) async {
    await _localDataSource.saveLastSelectedLocation(locationName);
  }

  @override
  String? getLastSelectedLocation() {
    return _localDataSource.getLastSelectedLocation();
  }

  @override
  Future<void> clearLastSelectedLocation() async {
    await _localDataSource.clearLastSelectedLocation();
  }

  // ========== SEARCH HISTORY ==========

  @override
  Future<List<LocationModel>> getSearchHistory() async {
    return await _localDataSource.getSearchHistory();
  }

  @override
  Future<void> addToHistory(LocationModel location) async {
    await _localDataSource.addToHistory(location);
  }

  @override
  Future<bool> removeFromHistory(LocationModel location) async {
    return await _localDataSource.removeFromHistory(location);
  }

  @override
  bool get isHistoryEmpty => _localDataSource.isHistoryEmpty;

  // ========== LOCATION SEARCH API ==========

  @override
  Future<List<LocationModel>> searchLocations(String query) async {
    return await _remoteDataSource.searchLocations(query);
  }
}
