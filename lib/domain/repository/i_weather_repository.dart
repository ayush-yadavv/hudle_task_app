import 'package:hudle_task_app/domain/models/weather_data_model/weather_model.dart';

/// Interface for weather data repository.
abstract class IWeatherRepository {
  Future<void> init();
  Future<void> clearWeatherCache(String stationName);
  Future<void> clearAllCache();

  Future<WeatherModel> getWeatherByCity(
    String stationName, {
    bool forceRefresh = false,
  });

  Future<WeatherModel> getWeatherByCoordinates({
    required double lat,
    required double lon,
    bool forceRefresh = false,
  });
}
