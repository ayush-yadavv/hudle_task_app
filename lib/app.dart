import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hudle_task_app/features/home/ui/home_screen.dart';
import 'package:hudle_task_app/features/network_manager/network_bloc.dart';
import 'package:hudle_task_app/features/settings/bloc/settings_bloc.dart';
import 'package:hudle_task_app/features/settings/bloc/settings_state.dart';
import 'package:hudle_task_app/utils/constants/app_configs.dart';
import 'package:hudle_task_app/utils/constants/app_enums.dart';
import 'package:hudle_task_app/utils/popups/toast_helper.dart';
import 'package:hudle_task_app/utils/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// Converts AppThemeMode to Flutter's ThemeMode
  ThemeMode _getThemeMode(AppThemeMode appThemeMode) {
    switch (appThemeMode) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (previous, current) =>
          previous.settings.themeMode != current.settings.themeMode,
      builder: (context, settingsState) {
        return MaterialApp(
          title: AppConfigs.applicationName,
          themeMode: _getThemeMode(settingsState.settings.themeMode),
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          darkTheme: AppTheme.darkTheme,
          builder: (context, child) {
            return BlocListener<NetworkBloc, NetworkState>(
              listener: (context, state) {
                if (state is NetworkFailure) {
                  SToast.showToast(
                    context,
                    'No Internet Connection',
                    position: ToastGravity.BOTTOM,
                  );
                }
              },
              child: child!,
            );
          },
          home: const HomeScreen(),
        );
      },
    );
  }
}
