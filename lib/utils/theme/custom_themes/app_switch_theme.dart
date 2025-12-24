import 'package:flutter/material.dart';
import 'package:hudle_task_app/utils/constants/colors.dart';

class AppSwitchTheme {
  AppSwitchTheme._();

  static SwitchThemeData lightSwitchTheme = SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return SColors.primary;
      }
      return SColors.grey;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return SColors.primary.withValues(alpha: 0.5);
      }
      return SColors.darkGrey;
    }),
    splashRadius: 20,
  );

  static SwitchThemeData darkSwitchTheme = SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return SColors.primary;
      }
      return SColors.grey;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return SColors.primary.withValues(alpha: 0.5);
      }
      return SColors.darkGrey;
    }),
    splashRadius: 20,
  );
}
