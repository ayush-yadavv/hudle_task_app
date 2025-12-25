import 'package:dio/dio.dart';
import 'package:hudle_task_app/domain/models/location_data_model/location_model.dart';
import 'package:hudle_task_app/utils/dio/dio_client.dart';
import 'package:hudle_task_app/utils/exceptions/api_exception.dart';
import 'package:hudle_task_app/utils/logger/logger.dart';

abstract class IGeolocationRemoteDataSource {
  Future<List<LocationModel>> searchLocations(String query);
}

class GeolocationRemoteDataSource implements IGeolocationRemoteDataSource {
  final DioClient _dioClient;

  GeolocationRemoteDataSource({required DioClient dioClient})
    : _dioClient = dioClient;

  @override
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

      return results.map((json) {
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
    } on DioException catch (e) {
      TLogger.error('DioError searching locations: "$query"', error: e);
      throw _dioClient.handleDioError(e);
    } catch (e) {
      TLogger.error('Unexpected error searching locations: "$query"', error: e);
      throw ApiException(
        message: 'Failed to search locations: ${e.toString()}',
        errorType: 'invalid_data',
      );
    }
  }
}
