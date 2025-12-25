import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hudle_task_app/domain/models/weather_data_model/weather_model.dart';
import 'package:hudle_task_app/utils/logger/logger.dart';

abstract class IWeatherLocalDataSource {
  Future<void> init();
  Future<void> cacheWeather(String key, WeatherModel weather);
  Future<WeatherModel?> getLastWeather(String key);
  Future<void> clearWeatherCache(String key);
  Future<void> clearAllCache();
}

class WeatherLocalDataSource implements IWeatherLocalDataSource {
  late Box<WeatherModel> _weatherBox;

  @visibleForTesting
  set weatherBox(Box<WeatherModel> box) => _weatherBox = box;

  @override
  Future<void> init() async {
    _weatherBox = await Hive.openBox<WeatherModel>('weather_cache');
    TLogger.info('WeatherLocalDataSource initialized');
  }

  @override
  Future<void> cacheWeather(String key, WeatherModel weather) async {
    await _weatherBox.put(key.toLowerCase(), weather);
  }

  @override
  Future<WeatherModel?> getLastWeather(String key) async {
    return _weatherBox.get(key.toLowerCase());
  }

  @override
  Future<void> clearWeatherCache(String key) async {
    await _weatherBox.delete(key.toLowerCase());
  }

  @override
  Future<void> clearAllCache() async {
    await _weatherBox.clear();
  }
}
