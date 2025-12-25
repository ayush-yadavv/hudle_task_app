import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hudle_task_app/app.dart';
import 'package:hudle_task_app/data/repository/settings_repository.dart';
import 'package:hudle_task_app/domain/models/location_data_model/location_model.dart';
import 'package:hudle_task_app/domain/models/settings_data_model/settings_model.dart';
import 'package:hudle_task_app/domain/models/weather_data_model/weather_model.dart';
import 'package:hudle_task_app/domain/repository/i_geolocation_repository.dart';
import 'package:hudle_task_app/domain/repository/i_weather_repository.dart';
import 'package:hudle_task_app/features/network_manager/network_bloc.dart';
import 'package:hudle_task_app/features/settings/bloc/settings_bloc.dart';
import 'package:hudle_task_app/features/settings/bloc/settings_event.dart';
import 'package:hudle_task_app/features/weather/bloc/weather_bloc.dart';
import 'package:hudle_task_app/utils/di/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(WeatherModelAdapter());
  Hive.registerAdapter(LocationModelAdapter());
  Hive.registerAdapter(SettingsModelAdapter());

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Setup Service Locator (DI)
  await setupServiceLocator();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NetworkBloc()..add(NetworkObserve())),
        BlocProvider(
          create: (context) =>
              SettingsBloc(settingsRepository: getIt<SettingsRepository>())
                ..add(LoadSettings()),
        ),
        BlocProvider(
          create: (context) => WeatherBloc(
            weatherRepository: getIt<IWeatherRepository>(),
            geolocationRepository: getIt<IGeolocationRepository>(),
            networkBloc: context.read<NetworkBloc>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
