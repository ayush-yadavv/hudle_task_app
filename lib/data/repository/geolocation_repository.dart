import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hudle_task_app/domain/models/location_model.dart';
import 'package:hudle_task_app/utils/dio/dio_client.dart';
import 'package:hudle_task_app/utils/exceptions/api_exception.dart';
import 'package:hudle_task_app/utils/logger/logger.dart';

/// Repository class responsible for location-related operations.
///
/// It manages:
/// - Searching for locations using the Open-Meteo Geocoding API.
/// - Persisting the user's last selected location.
/// - Maintaining a local search history using Hive.
class GeolocationRepository {
  final DioClient _dioClient;

  GeolocationRepository({required DioClient dioClient})
    : _dioClient = dioClient;

  late Box<String> _preferencesBox;
  late Box<LocationModel> _historyBox;

  /// Internal Hive box for storing simple application preferences (e.g., last_selected_city).
  @visibleForTesting
  set preferencesBox(Box<String> box) => _preferencesBox = box;

  /// Internal Hive box for storing user's location search history.
  @visibleForTesting
  set historyBox(Box<LocationModel> box) => _historyBox = box;

  /// Initializes the repository by opening necessary Hive boxes.
  ///
  /// This must be called before using any methods that involve storage.
  Future<void> init() async {
    _preferencesBox = await Hive.openBox<String>('app_preferences');
    _historyBox = await Hive.openBox<LocationModel>('search_history');
    TLogger.info('GeolocationRepository initialized');
  }

  // ========== PREFERENCES ==========

  /// Persists the name of the last selected location.
  Future<void> saveLastSelectedLocation(String locationName) async {
    await _preferencesBox.put('last_selected_city', locationName);
    TLogger.debug('Saved last selected location: $locationName');
  }

  /// Retrieves the name of the last selected location from storage.
  ///
  /// Returns null if no location has been saved.
  String? getLastSelectedLocation() {
    final location = _preferencesBox.get('last_selected_city');
    TLogger.debug('Retrieved last selected location: $location');
    return location;
  }

  /// Clears the last selected location from storage.
  Future<void> clearLastSelectedLocation() async {
    await _preferencesBox.delete('last_selected_city');
    TLogger.debug('Cleared last selected location');
  }

  // ========== SEARCH HISTORY ==========

  /// Retrieves the complete location search history.
  ///
  /// Results are returned in reverse chronological order (most recent first).
  Future<List<LocationModel>> getSearchHistory() async {
    final history = _historyBox.values.toList().reversed.toList();
    TLogger.debug('Loaded ${history.length} history items');
    return history;
  }

  /// Adds a [location] to the search history.
  ///
  /// If the location already exists in history, the old entry is removed
  /// before adding the new one to the top.
  /// The history is limited to the last 10 unique entries.
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

  /// Removes a specific [location] from the search history.
  ///
  /// Returns true if the location was found and removed.
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

  /// Indicates whether the search history is currently empty.
  bool get isHistoryEmpty => _historyBox.isEmpty;

  // ========== LOCATION SEARCH API ==========

  /// Searches for locations matching the [query] string using the Open-Meteo Geocoding API.
  ///
  /// This API provides a fuzzy search that is well-suited for city and region lookups.
  /// Returns a list of [LocationModel] matching results.
  /// Throws [ApiException] if the search fails.
  Future<List<LocationModel>> searchLocations(String query) async {
    TLogger.debug('Searching locations for query: "$query"');
    try {
      // Open-Meteo Geocoding API (No API Key needed)
      final response = await _dioClient.get(
        'https://geocoding-api.open-meteo.com/v1/search',
        queryParameters: {
          'name': query,
          'count': 10,
          'language': 'en',
          'format': 'json',
        },
      );

      if (response == null) {
        TLogger.warning(
          'Empty response from geocoding API for query: "$query"',
        );
        return [];
      }

      if (response['results'] == null) {
        TLogger.info('No results found for query: "$query"');
        return [];
      }

      final results = response['results'] as List;

      final locations = results.map((json) {
        final map = json as Map<String, dynamic>;
        return LocationModel(
          name: map['name'] ?? '',
          country: map['country'] ?? '',
          // Open-Meteo uses 'admin1' for state/region
          state: map['admin1'] ?? '',
          // Open-Meteo uses full names 'latitude' and 'longitude'
          lat: (map['latitude'] as num).toDouble(),
          lon: (map['longitude'] as num).toDouble(),
          id: map['id']?.toString() ?? "${map['latitude']}_${map['longitude']}",
        );
      }).toList();

      TLogger.info('Found ${locations.length} locations for query: "$query"');
      return locations;
    } on DioException catch (e) {
      TLogger.error('DioError searching locations: "$query"', error: e);
      throw _handleDioError(e);
    } catch (e) {
      TLogger.error('Unexpected error searching locations: "$query"', error: e);
      throw ApiException(
        message: 'Failed to search locations: ${e.toString()}',
        errorType: 'invalid_data',
      );
    }
  }

  /// Converts a [DioException] into a domain-specific [ApiException].
  ApiException _handleDioError(DioException error) {
    String errorType;
    String message;
    int? statusCode;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorType = 'connection_timeout';
        message = 'Connection timeout';
        break;

      case DioExceptionType.connectionError:
        errorType = 'connection_error';
        message = 'Connection failed';
        break;

      case DioExceptionType.badResponse:
        errorType = 'bad_response';
        statusCode = error.response?.statusCode;
        message =
            error.response?.data['message'] ??
            'Server error: ${error.response?.statusCode}';
        break;

      case DioExceptionType.cancel:
        errorType = 'cancelled';
        message = 'Request cancelled';
        break;

      default:
        errorType = 'unknown';
        message = 'An unexpected error occurred';
    }

    TLogger.error('DioException Handled: $errorType - $message', error: error);

    return ApiException(
      message: message,
      statusCode: statusCode,
      errorType: errorType,
    );
  }
}
