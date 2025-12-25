import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hudle_task_app/data/repository/geolocation_repository.dart';
import 'package:hudle_task_app/data/repository/settings_repository.dart';
import 'package:hudle_task_app/data/repository/weather_repository.dart';
import 'package:hudle_task_app/domain/repository/i_geolocation_repository.dart';
import 'package:hudle_task_app/domain/repository/i_weather_repository.dart';
import 'package:hudle_task_app/utils/dio/dio_client.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // 1. Register External Services (Dio)
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.openweathermap.org/data/2.5',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    // Add LogInterceptor or others here if needed
    return dio;
  });

  // 2. Register Core Utilities
  getIt.registerLazySingleton<DioClient>(() => DioClient(getIt<Dio>()));

  // 3. Register Repositories
  getIt.registerLazySingleton<IWeatherRepository>(
    () => WeatherRepository(dioClient: getIt<DioClient>()),
  );

  getIt.registerLazySingleton<IGeolocationRepository>(
    () => GeolocationRepository(dioClient: getIt<DioClient>()),
  );

  getIt.registerLazySingleton<SettingsRepository>(() => SettingsRepository());

  // Initialize Repositories (Hive boxes, etc.)
  await getIt<IWeatherRepository>().init();
  await getIt<IGeolocationRepository>().init();
  await getIt<SettingsRepository>().init();
}
