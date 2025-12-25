import 'package:hudle_task_app/domain/models/location_data_model/location_model.dart';

/// Interface for geolocation and history repository.
abstract class IGeolocationRepository {
  Future<void> init();

  Future<void> saveLastSelectedLocation(String locationName);

  String? getLastSelectedLocation();

  Future<void> clearLastSelectedLocation();

  Future<List<LocationModel>> getSearchHistory();

  Future<void> addToHistory(LocationModel location);

  Future<bool> removeFromHistory(LocationModel location);

  bool get isHistoryEmpty;

  Future<List<LocationModel>> searchLocations(String query);
}
