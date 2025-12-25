import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hudle_task_app/domain/models/weather_data_model/weather_model.dart';
import 'package:hudle_task_app/utils/dio/dio_client.dart';
import 'package:hudle_task_app/utils/exceptions/api_exception.dart';
import 'package:hudle_task_app/utils/logger/logger.dart';

abstract class IWeatherRemoteDataSource {
  Future<WeatherModel> getWeatherByCity(String stationName);
  Future<WeatherModel> getWeatherByCoordinates(double lat, double lon);
}

class WeatherRemoteDataSource implements IWeatherRemoteDataSource {
  final DioClient _dioClient;
  final String _apiKey;

  WeatherRemoteDataSource({required DioClient dioClient, String? apiKey})
    : _dioClient = dioClient,
      _apiKey = apiKey ?? dotenv.env['OPEN_WEATHER_API_KEY'] ?? '';

  @override
  Future<WeatherModel> getWeatherByCity(String stationName) async {
    try {
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
      return currentWeather.copyWith(
        minTemp: extremes['minTemp'],
        maxTemp: extremes['maxTemp'],
        lastFetched: DateTime.now(),
      );
    } on DioException catch (e) {
      TLogger.error(
        'DioError fetching weather for station: $stationName',
        error: e,
      );
      throw _dioClient.handleDioError(e);
    } catch (e) {
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

  @override
  Future<WeatherModel> getWeatherByCoordinates(double lat, double lon) async {
    try {
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
      return currentWeather.copyWith(
        minTemp: extremes['minTemp'],
        maxTemp: extremes['maxTemp'],
        lastFetched: DateTime.now(),
      );
    } on DioException catch (e) {
      TLogger.error(
        'DioError fetching weather for coordinates: $lat, $lon',
        error: e,
      );
      throw _dioClient.handleDioError(e);
    } catch (e) {
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
      if (response == null || response['list'] == null) return {};

      final list = response['list'] as List;
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
}
