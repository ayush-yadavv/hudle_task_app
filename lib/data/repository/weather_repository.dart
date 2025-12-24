import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hudle_task_app/domain/models/location_model.dart';
import 'package:hudle_task_app/domain/models/weather_model.dart';
import 'package:hudle_task_app/utils/dio/dio_client.dart';
import 'package:hudle_task_app/utils/exceptions/api_exception.dart';

/// Repository for weather-related API calls
/// Implements the Repository pattern to separate data layer from business logic
class WeatherRepository {
  final DioClient _dioClient;
  final String _apiKey;

  WeatherRepository({DioClient? dioClient})
    : _dioClient = dioClient ?? DioClient(),
      _apiKey = dotenv.env['OPEN_WEATHER_API_KEY'] ?? '';

  /// Fetch weather data by city name
  Future<WeatherModel> getWeatherByCity(String cityName) async {
    try {
      // Fetch current weather and forecast extremes in parallel
      final results = await Future.wait([
        _dioClient.get(
          '/weather',
          queryParameters: {'q': cityName, 'appid': _apiKey},
        ),
        _getDailyExtremes(q: cityName),
      ]);

      final currentRes = results[0];
      final extremes = results[1] as Map<String, double>;

      if (currentRes == null) {
        throw ApiException(
          message: 'No data received from server',
          errorType: 'invalid_data',
        );
      }

      final currentWeather = WeatherModel.fromJson(
        currentRes as Map<String, dynamic>,
      );

      return currentWeather.copyWith(
        minTemp: extremes['minTemp'],
        maxTemp: extremes['maxTemp'],
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch weather data: ${e.toString()}',
        errorType: 'invalid_data',
      );
    }
  }

  /// Fetch weather data by coordinates
  Future<WeatherModel> getWeatherByCoordinates({
    required double lat,
    required double lon,
  }) async {
    try {
      // Fetch current weather and forecast extremes in parallel
      final results = await Future.wait([
        _dioClient.get(
          '/weather',
          queryParameters: {'lat': lat, 'lon': lon, 'appid': _apiKey},
        ),
        _getDailyExtremes(lat: lat, lon: lon),
      ]);

      final currentRes = results[0];
      final extremes = results[1] as Map<String, double>;

      if (currentRes == null) {
        throw ApiException(
          message: 'No data received from server',
          errorType: 'invalid_data',
        );
      }

      final currentWeather = WeatherModel.fromJson(
        currentRes as Map<String, dynamic>,
      );

      return currentWeather.copyWith(
        minTemp: extremes['minTemp'],
        maxTemp: extremes['maxTemp'],
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch weather data: ${e.toString()}',
        errorType: 'invalid_data',
      );
    }
  }

  /// Helper to fetch daily min/max from forecast API (approx. next 24 hours)
  Future<Map<String, double>> _getDailyExtremes({
    String? q,
    double? lat,
    double? lon,
  }) async {
    try {
      final Map<String, dynamic> params = {'appid': _apiKey};
      if (q != null) params['q'] = q;
      if (lat != null && lon != null) {
        params['lat'] = lat;
        params['lon'] = lon;
      }

      final response = await _dioClient.get(
        '/forecast',
        queryParameters: params,
      );

      if (response == null || response['list'] == null) {
        return {};
      }

      final list = response['list'] as List;
      // We take the first 8 segments (3 hours each = 24 hours) to find min/max
      double? min;
      double? max;

      for (var i = 0; i < (list.length < 8 ? list.length : 8); i++) {
        final item = list[i] as Map<String, dynamic>;
        final main = item['main'] as Map<String, dynamic>;
        final temp = (main['temp'] as num).toDouble();

        if (min == null || temp < min) min = temp;
        if (max == null || temp > max) max = temp;
      }

      return {'minTemp': min ?? 0.0, 'maxTemp': max ?? 0.0};
    } catch (_) {
      return {};
    }
  }

  /// Search for locations by name
  Future<List<LocationModel>> searchLocations(String query) async {
    try {
      final response = await _dioClient.get(
        '/geo/1.0/direct',
        queryParameters: {'q': query, 'limit': 5, 'appid': _apiKey},
      );

      if (response == null) {
        throw ApiException(
          message: 'No data received from server',
          errorType: 'invalid_data',
        );
      }

      if (response is! List) {
        throw ApiException(
          message: 'Invalid response format',
          errorType: 'invalid_data',
        );
      }

      return response
          .map((json) => LocationModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException(
        message: 'Failed to parse location data: ${e.toString()}',
        errorType: 'invalid_data',
      );
    }
  }

  /// Handle Dio errors and convert to ApiException
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

    return ApiException(
      message: message,
      statusCode: statusCode,
      errorType: errorType,
    );
  }
}
