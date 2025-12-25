import 'package:hudle_task_app/data/datasources/weather/weather_local_data_source.dart';
import 'package:hudle_task_app/data/datasources/weather/weather_remote_data_source.dart';
import 'package:hudle_task_app/domain/models/weather_data_model/weather_model.dart';
import 'package:hudle_task_app/domain/repository/i_weather_repository.dart';
import 'package:hudle_task_app/utils/exceptions/api_exception.dart';
import 'package:hudle_task_app/utils/logger/logger.dart';

/// Repository class responsible for coordinating weather data operations.
///
/// It manages:
/// - Fetching data from [IWeatherRemoteDataSource].
/// - Caching data via [IWeatherLocalDataSource].
/// - Fallback to cache when offline.
class WeatherRepository implements IWeatherRepository {
  final IWeatherRemoteDataSource _remoteDataSource;
  final IWeatherLocalDataSource _localDataSource;

  WeatherRepository({
    required IWeatherRemoteDataSource remoteDataSource,
    required IWeatherLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  /// Initializes the local data source.
  @override
  Future<void> init() async {
    await _localDataSource.init();
    TLogger.info('WeatherRepository initialized');
  }

  // ========== WEATHER CACHE ==========

  @override
  Future<void> clearWeatherCache(String stationName) async {
    await _localDataSource.clearWeatherCache(stationName);
    TLogger.debug('Cleared weather cache for: $stationName');
  }

  @override
  Future<void> clearAllCache() async {
    await _localDataSource.clearAllCache();
    TLogger.debug('Cleared all weather cache');
  }

  // ========== WEATHER API ==========

  @override
  Future<WeatherModel> getWeatherByCity(
    String stationName, {
    bool forceRefresh = false,
  }) async {
    final cachedWeather = await _localDataSource.getLastWeather(stationName);
    final now = DateTime.now();

    // 1. Check if cache is valid
    if (!forceRefresh &&
        cachedWeather != null &&
        now.difference(cachedWeather.lastFetched).inMinutes < 15) {
      TLogger.debug('Returning cached weather for station: $stationName');
      return cachedWeather;
    }

    TLogger.info('Fetching fresh weather for station: $stationName');

    try {
      // 2. Fetch fresh data
      final weather = await _remoteDataSource.getWeatherByCity(stationName);

      // 3. Cache it
      await _localDataSource.cacheWeather(stationName, weather);

      TLogger.info('Successfully fetched weather for station: $stationName');
      return weather;
    } on ApiException catch (e) {
      // 4. Offline Fallback
      if (!forceRefresh && cachedWeather != null) {
        TLogger.warning(
          'Network error fetching station $stationName, returning expired cache. Error: ${e.message}',
        );
        return cachedWeather;
      }
      rethrow;
    } catch (e) {
      if (!forceRefresh && cachedWeather != null) {
        TLogger.warning(
          'Unexpected error fetching station $stationName, returning expired cache. Error: $e',
        );
        return cachedWeather;
      }
      throw ApiException(
        message: 'Failed to fetch weather data: ${e.toString()}',
        errorType: 'invalid_data',
      );
    }
  }

  @override
  Future<WeatherModel> getWeatherByCoordinates({
    required double lat,
    required double lon,
    bool forceRefresh = false,
  }) async {
    final cacheKey = '${lat.toStringAsFixed(2)}_${lon.toStringAsFixed(2)}';
    final cachedWeather = await _localDataSource.getLastWeather(cacheKey);
    final now = DateTime.now();

    if (!forceRefresh &&
        cachedWeather != null &&
        now.difference(cachedWeather.lastFetched).inMinutes < 15) {
      TLogger.debug('Returning cached weather for coordinates: $lat, $lon');
      return cachedWeather;
    }

    TLogger.info('Fetching fresh weather for coordinates: $lat, $lon');

    try {
      final weather = await _remoteDataSource.getWeatherByCoordinates(lat, lon);

      await _localDataSource.cacheWeather(cacheKey, weather);

      TLogger.info('Successfully fetched weather for coordinates: $lat, $lon');
      return weather;
    } on ApiException catch (e) {
      if (!forceRefresh && cachedWeather != null) {
        TLogger.warning(
          'Network error fetching coordinates $lat, $lon, returning expired cache. Error: ${e.message}',
        );
        return cachedWeather;
      }
      rethrow;
    } catch (e) {
      if (!forceRefresh && cachedWeather != null) {
        TLogger.warning(
          'Unexpected error fetching coordinates $lat, $lon, returning expired cache. Error: $e',
        );
        return cachedWeather;
      }
      throw ApiException(
        message: 'Failed to fetch weather data: ${e.toString()}',
        errorType: 'invalid_data',
      );
    }
  }
}
