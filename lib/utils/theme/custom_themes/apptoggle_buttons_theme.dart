import 'package:flutter/material.dart';
import 'package:hudle_task_app/utils/constants/colors.dart';

class ApptoggleButtonsTheme {
  ApptoggleButtonsTheme._();

  static ToggleButtonsThemeData lightToggleButtonsTheme =
      ToggleButtonsThemeData(
        borderRadius: BorderRadius.circular(16),
        selectedColor: SColors.primary,
        fillColor: const Color.fromARGB(59, 226, 129, 177),
        selectedBorderColor: SColors.primary,
      );

  static ToggleButtonsThemeData darkToggleButtonsTheme = ToggleButtonsThemeData(
    borderRadius: BorderRadius.circular(16),
    selectedColor: SColors.primary,
    fillColor: const Color.fromARGB(59, 226, 129, 177),
    selectedBorderColor: SColors.primary,
  );
}
