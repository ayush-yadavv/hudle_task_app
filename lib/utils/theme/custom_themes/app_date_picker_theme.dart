import 'package:flutter/material.dart';
import 'package:hudle_task_app/utils/constants/colors.dart';

class AppDatePickerTheme {
  AppDatePickerTheme._();

  static DatePickerThemeData lightDatePickerTheme = DatePickerThemeData(
    backgroundColor: SColors.light,
    headerBackgroundColor: SColors.primary,
    headerForegroundColor: SColors.white,

    dayForegroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return SColors.white;
      }
      return SColors.textPrimary;
    }),
    dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return SColors.primary;
      }
      return SColors.transparent;
    }),
    yearForegroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return SColors.white;
      }
      return SColors.textPrimary;
    }),
    yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return SColors.primary;
      }
      return SColors.transparent;
    }),
    todayForegroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return SColors.white;
      }
      return SColors.primary;
    }),
    todayBorder: BorderSide(color: SColors.primary),
    rangePickerHeaderBackgroundColor: SColors.primary,
    rangePickerHeaderForegroundColor: SColors.white,
    rangeSelectionBackgroundColor: SColors.primaryLightAccent,
    rangeSelectionOverlayColor: WidgetStateProperty.all(
      SColors.primaryLightAccent,
    ),
    confirmButtonStyle: ButtonStyle(
      padding: WidgetStatePropertyAll(EdgeInsets.all(12)),
      foregroundColor: WidgetStateProperty.all(SColors.primary),
    ),
    cancelButtonStyle: ButtonStyle(
      padding: WidgetStatePropertyAll(EdgeInsets.all(12)),
      foregroundColor: WidgetStateProperty.all(SColors.textSecondary),
    ),
  );

  static DatePickerThemeData darkDatePickerTheme = DatePickerThemeData(
    backgroundColor: SColors.dark,
    headerBackgroundColor: SColors.primary,
    headerForegroundColor: SColors.white,
    dayForegroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return SColors.white;
      }
      return SColors.textWhite;
    }),
    dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return SColors.primary;
      }
      return SColors.transparent;
    }),
    yearForegroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return SColors.white;
      }
      return SColors.textWhite;
    }),
    yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return SColors.primary;
      }
      return SColors.transparent;
    }),
    todayForegroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return SColors.white;
      }
      return SColors.primary;
    }),
    todayBorder: BorderSide(color: SColors.primary),
    rangePickerHeaderBackgroundColor: SColors.primary,
    rangePickerHeaderForegroundColor: SColors.white,
    rangeSelectionBackgroundColor: SColors.primaryDarkAccent,
    rangeSelectionOverlayColor: WidgetStateProperty.all(
      SColors.primaryDarkAccent,
    ),
    confirmButtonStyle: ButtonStyle(
      padding: WidgetStatePropertyAll(EdgeInsets.all(12)),
      foregroundColor: WidgetStateProperty.all(SColors.primary),
    ),
    cancelButtonStyle: ButtonStyle(
      padding: WidgetStatePropertyAll(EdgeInsets.all(12)),
      foregroundColor: WidgetStateProperty.all(SColors.grey),
    ),
  );
}
