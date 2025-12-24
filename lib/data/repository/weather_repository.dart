import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:hudle_task_app/domain/models/weather_model.dart';
import 'package:hudle_task_app/utils/dio/dio_client.dart';
import 'package:hudle_task_app/utils/exceptions/api_exception.dart';
import 'package:hudle_task_app/utils/logger/logger.dart';

/// Repository for handling weather API calls and weather data caching
class WeatherRepository {
  final DioClient _dioClient;
  final String _apiKey;

  WeatherRepository({required DioClient dioClient, String? apiKey})
    : _dioClient = dioClient,
      _apiKey = apiKey ?? dotenv.env['OPEN_WEATHER_API_KEY'] ?? '';

  late Box<WeatherModel> _weatherBox;

  @visibleForTesting
  set weatherBox(Box<WeatherModel> box) => _weatherBox = box;

  @visibleForTesting
  Box<WeatherModel> get weatherBox => _weatherBox;

  /// Initialize Hive box for weather caching
  Future<void> init() async {
    _weatherBox = await Hive.openBox<WeatherModel>('weather_cache');
    TLogger.info('WeatherRepository initialized');
  }

  // ========== WEATHER CACHE ==========

  /// Remove cached weather for a specific station
  Future<void> clearWeatherCache(String stationName) async {
    final cacheKey = stationName.toLowerCase();
    await _weatherBox.delete(cacheKey);
    TLogger.debug('Cleared weather cache for: $stationName');
  }

  /// Clear all weather cache
  Future<void> clearAllCache() async {
    await _weatherBox.clear();
    TLogger.debug('Cleared all weather cache');
  }

  // ========== WEATHER API ==========

  /// Fetch weather data by station name
  /// [forceRefresh] - If true, bypasses the 15-minute TTL and fetches fresh data
  Future<WeatherModel> getWeatherByCity(
    String stationName, {
    bool forceRefresh = false,
  }) async {
    final cacheKey = stationName.toLowerCase();
    final cachedWeather = _weatherBox.get(cacheKey);
    final now = DateTime.now();

    // 1. Check if cache is valid (exists, not expired, and not forced refresh)
    if (!forceRefresh &&
        cachedWeather != null &&
        now.difference(cachedWeather.lastFetched).inMinutes < 15) {
      TLogger.debug('Returning cached weather for station: $stationName');
      return cachedWeather;
    }

    TLogger.info('Fetching fresh weather for station: $stationName');

    try {
      // 2. Fetch current weather and forecast extremes in parallel
      final results = await Future.wait([
        _dioClient.get(
          '/weather',
          queryParameters: {'q': stationName, 'appid': _apiKey},
        ),
        _getDailyExtremes(q: stationName),
      ]);

      final currentRes = results[0];
      final extremes = results[1] as Map<String, double>;

      if (currentRes == null) {
        throw ApiException(
          message: 'No data received from server',
          errorType: 'invalid_data',
        );
      }

      var currentWeather = WeatherModel.fromJson(
        currentRes as Map<String, dynamic>,
      );

      // Merge daily extremes
      currentWeather = currentWeather.copyWith(
        minTemp: extremes['minTemp'],
        maxTemp: extremes['maxTemp'],
        lastFetched: DateTime.now(),
      );

      // 3. Save to local cache
      await _weatherBox.put(cacheKey, currentWeather);

      TLogger.info('Successfully fetched weather for station: $stationName');
      return currentWeather;
    } on DioException catch (e) {
      // 4. Offline Fallback: If network fails, return expired cache if available
      if (cachedWeather != null) {
        TLogger.warning(
          'Network error fetching station $stationName, returning expired cache. Error: ${e.message}',
        );
        return cachedWeather;
      }
      TLogger.error(
        'DioError fetching weather for station: $stationName',
        error: e,
      );
      throw _handleDioError(e);
    } catch (e) {
      // Offline Fallback for other errors
      if (cachedWeather != null) {
        TLogger.warning(
          'Unexpected error fetching station $stationName, returning expired cache. Error: $e',
        );
        return cachedWeather;
      }
      TLogger.error(
        'Unexpected error fetching weather for station: $stationName',
        error: e,
      );
      throw ApiException(
        message: 'Failed to fetch weather data: ${e.toString()}',
        errorType: 'invalid_data',
      );
    }
  }

  /// Fetch weather data by coordinates
  /// [forceRefresh] - If true, bypasses the 15-minute TTL and fetches fresh data
  Future<WeatherModel> getWeatherByCoordinates({
    required double lat,
    required double lon,
    bool forceRefresh = false,
  }) async {
    // Generate a composite key for coordinates (rounded to 2 decimal places)
    final cacheKey = '${lat.toStringAsFixed(2)}_${lon.toStringAsFixed(2)}';
    final cachedWeather = _weatherBox.get(cacheKey);
    final now = DateTime.now();

    // 1. Check if cache is valid (exists, not expired, and not forced refresh)
    if (!forceRefresh &&
        cachedWeather != null &&
        now.difference(cachedWeather.lastFetched).inMinutes < 15) {
      TLogger.debug('Returning cached weather for coordinates: $lat, $lon');
      return cachedWeather;
    }

    TLogger.info('Fetching fresh weather for coordinates: $lat, $lon');

    try {
      // 2. Fetch current weather and forecast extremes in parallel
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

      var currentWeather = WeatherModel.fromJson(
        currentRes as Map<String, dynamic>,
      );

      // Merge daily extremes
      currentWeather = currentWeather.copyWith(
        minTemp: extremes['minTemp'],
        maxTemp: extremes['maxTemp'],
        lastFetched: DateTime.now(),
      );

      // 3. Save to local cache
      await _weatherBox.put(cacheKey, currentWeather);

      TLogger.info('Successfully fetched weather for coordinates: $lat, $lon');
      return currentWeather;
    } on DioException catch (e) {
      // 4. Offline Fallback: If network fails, return expired cache if available
      if (cachedWeather != null) {
        TLogger.warning(
          'Network error fetching coordinates $lat, $lon, returning expired cache. Error: ${e.message}',
        );
        return cachedWeather;
      }
      TLogger.error(
        'DioError fetching weather for coordinates: $lat, $lon',
        error: e,
      );
      throw _handleDioError(e);
    } catch (e) {
      // Offline Fallback for other errors
      if (cachedWeather != null) {
        TLogger.warning(
          'Unexpected error fetching coordinates $lat, $lon, returning expired cache. Error: $e',
        );
        return cachedWeather;
      }
      TLogger.error(
        'Unexpected error fetching weather for coordinates: $lat, $lon',
        error: e,
      );
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
      // If forecast fails, return empty - min/max might be missing
      return {};
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

    TLogger.error('DioException Handled: $errorType - $message', error: error);

    return ApiException(
      message: message,
      statusCode: statusCode,
      errorType: errorType,
    );
  }
}
