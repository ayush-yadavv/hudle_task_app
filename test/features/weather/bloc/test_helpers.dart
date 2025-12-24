import 'package:hudle_task_app/data/repository/geolocation_repository.dart';
import 'package:hudle_task_app/data/repository/weather_repository.dart';
import 'package:hudle_task_app/domain/models/location_model.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

class MockGeolocationRepository extends Mock implements GeolocationRepository {}

void registerCommonFallbacks() {
  registerFallbackValue(
    LocationModel(name: 'fallback', lat: 0, lon: 0, country: '', id: '0'),
  );
}
