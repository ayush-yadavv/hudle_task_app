import 'package:flutter/material.dart';
import 'package:hudle_task_app/utils/constants/colors.dart';

class AppSnackbarTheme {
  AppSnackbarTheme._();

  static SnackBarThemeData light = SnackBarThemeData(
    backgroundColor: SColors.white,
    behavior: SnackBarBehavior.floating,
    showCloseIcon: false,
    insetPadding: const EdgeInsets.all(18),
    contentTextStyle: const TextStyle(color: SColors.black),
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );

  static SnackBarThemeData dark = SnackBarThemeData(
    backgroundColor: SColors.black,
    behavior: SnackBarBehavior.floating,
    showCloseIcon: false,
    insetPadding: const EdgeInsets.all(18),
    contentTextStyle: const TextStyle(color: SColors.white),
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );
}
