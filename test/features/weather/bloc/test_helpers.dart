import 'package:bloc_test/bloc_test.dart';
import 'package:hudle_task_app/data/repository/geolocation_repository.dart';
import 'package:hudle_task_app/data/repository/weather_repository.dart';
import 'package:hudle_task_app/domain/models/location_model.dart';
import 'package:hudle_task_app/features/network_manager/network_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

class MockGeolocationRepository extends Mock implements GeolocationRepository {}

class MockNetworkBloc extends MockBloc<NetworkEvent, NetworkState>
    implements NetworkBloc {}

void registerCommonFallbacks() {
  registerFallbackValue(
    LocationModel(name: 'fallback', lat: 0, lon: 0, country: '', id: '0'),
  );
}
