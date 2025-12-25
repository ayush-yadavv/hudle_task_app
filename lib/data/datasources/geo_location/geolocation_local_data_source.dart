import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hudle_task_app/domain/models/location_data_model/location_model.dart';
import 'package:hudle_task_app/utils/logger/logger.dart';

abstract class IGeolocationLocalDataSource {
  Future<void> init();
  Future<void> saveLastSelectedLocation(String locationName);
  String? getLastSelectedLocation();
  Future<void> clearLastSelectedLocation();
  Future<List<LocationModel>> getSearchHistory();
  Future<void> addToHistory(LocationModel location);
  Future<bool> removeFromHistory(LocationModel location);
  bool get isHistoryEmpty;
}

class GeolocationLocalDataSource implements IGeolocationLocalDataSource {
  late Box<String> _preferencesBox;
  late Box<LocationModel> _historyBox;

  @visibleForTesting
  set preferencesBox(Box<String> box) => _preferencesBox = box;

  @visibleForTesting
  set historyBox(Box<LocationModel> box) => _historyBox = box;

  @override
  Future<void> init() async {
    _preferencesBox = await Hive.openBox<String>('app_preferences');
    _historyBox = await Hive.openBox<LocationModel>('search_history');
    TLogger.info('GeolocationLocalDataSource initialized');
  }

  @override
  Future<void> saveLastSelectedLocation(String locationName) async {
    await _preferencesBox.put('last_selected_city', locationName);
    TLogger.debug('Saved last selected location: $locationName');
  }

  @override
  String? getLastSelectedLocation() {
    return _preferencesBox.get('last_selected_city');
  }

  @override
  Future<void> clearLastSelectedLocation() async {
    await _preferencesBox.delete('last_selected_city');
    TLogger.debug('Cleared last selected location');
  }

  @override
  Future<List<LocationModel>> getSearchHistory() async {
    final history = _historyBox.values.toList().reversed.toList();
    TLogger.debug('Loaded ${history.length} history items');
    return history;
  }

  @override
  Future<void> addToHistory(LocationModel location) async {
    TLogger.debug('Adding to history: ${location.name}');

    // Check for duplicates
    final items = _historyBox.values.toList();
    final existingIndex = items.indexOf(location);

    if (existingIndex != -1) {
      TLogger.debug('Removing duplicate at index: $existingIndex');
      await _historyBox.deleteAt(existingIndex);
    }

    // Update lastFetched and add to end (most recent)
    final updatedLocation = location.copyWith(lastFetched: DateTime.now());
    await _historyBox.add(updatedLocation);
    TLogger.debug('Added to history. Total entries: ${_historyBox.length}');

    // Limit to 10 entries
    if (_historyBox.length > 10) {
      await _historyBox.deleteAt(0);
      TLogger.debug('Removed oldest entry to maintain limit');
    }
  }

  @override
  Future<bool> removeFromHistory(LocationModel location) async {
    final items = _historyBox.values.toList();
    final indexToRemove = items.indexOf(location);

    if (indexToRemove != -1) {
      await _historyBox.deleteAt(indexToRemove);
      TLogger.debug('Removed from history at index: $indexToRemove');
      return true;
    }

    TLogger.warning('Location not found in history: ${location.name}');
    return false;
  }

  @override
  bool get isHistoryEmpty => _historyBox.isEmpty;
}
