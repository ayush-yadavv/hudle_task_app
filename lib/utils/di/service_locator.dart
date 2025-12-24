import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hudle_task_app/data/repository/geolocation_repository.dart';
import 'package:hudle_task_app/data/repository/settings_repository.dart';
import 'package:hudle_task_app/data/repository/weather_repository.dart';
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
    return dio;
  });

  // 2. Register Core Utilities
  getIt.registerLazySingleton<DioClient>(() => DioClient(getIt<Dio>()));

  // 3. Register Repositories
  getIt.registerLazySingleton<WeatherRepository>(
    () => WeatherRepository(dioClient: getIt<DioClient>()),
  );

  getIt.registerLazySingleton<GeolocationRepository>(
    () => GeolocationRepository(dioClient: getIt<DioClient>()),
  );

  getIt.registerLazySingleton<SettingsRepository>(() => SettingsRepository());

  // Initialize Repositories (Hive boxes, etc.)
  await getIt<WeatherRepository>().init();
  await getIt<GeolocationRepository>().init();
  await getIt<SettingsRepository>().init();
}
