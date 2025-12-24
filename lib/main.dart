import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hudle_task_app/app.dart';
import 'package:hudle_task_app/data/repository/settings_repository.dart';
import 'package:hudle_task_app/data/repository/weather_repository.dart';
import 'package:hudle_task_app/domain/models/location_model.dart';
import 'package:hudle_task_app/domain/models/settings_model.dart';
import 'package:hudle_task_app/domain/models/weather_model.dart';
import 'package:hudle_task_app/features/network_manager/network_bloc.dart';
import 'package:hudle_task_app/features/settings/bloc/settings_bloc.dart';
import 'package:hudle_task_app/features/settings/bloc/settings_event.dart';
import 'package:hudle_task_app/features/weather/bloc/weather_bloc.dart';

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

  // Initialize Repositories
  final weatherRepository = WeatherRepository();
  final settingsRepository = SettingsRepository();
  await settingsRepository.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NetworkBloc()..add(NetworkObserve())),
        BlocProvider(
          create: (context) =>
              SettingsBloc(settingsRepository: settingsRepository)
                ..add(LoadSettings()),
        ),
        BlocProvider(
          create: (context) =>
              WeatherBloc(weatherRepository: weatherRepository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
