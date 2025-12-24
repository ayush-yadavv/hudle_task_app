import 'package:flutter/material.dart';
import 'package:hudle_task_app/utils/constants/colors.dart';
import 'package:hudle_task_app/utils/theme/custom_themes/app_date_picker_theme.dart';
import 'package:hudle_task_app/utils/theme/custom_themes/app_elevated_button_theme.dart';
import 'package:hudle_task_app/utils/theme/custom_themes/app_floating_action_button_theme.dart';
import 'package:hudle_task_app/utils/theme/custom_themes/app_slider_theme.dart';
import 'package:hudle_task_app/utils/theme/custom_themes/app_switch_theme.dart';
import 'package:hudle_task_app/utils/theme/custom_themes/app_text_button_theme.dart';
import 'package:hudle_task_app/utils/theme/custom_themes/appbar_theme.dart';
import 'package:hudle_task_app/utils/theme/custom_themes/appbottem_sheet_theme.dart';
import 'package:hudle_task_app/utils/theme/custom_themes/appcheckbox_theme.dart';
import 'package:hudle_task_app/utils/theme/custom_themes/appchip_theme.dart';
import 'package:hudle_task_app/utils/theme/custom_themes/appoutlined_button_theme.dart';
import 'package:hudle_task_app/utils/theme/custom_themes/apptext_form_field_theme.dart';
import 'package:hudle_task_app/utils/theme/custom_themes/apptoggle_buttons_theme.dart';
import 'package:hudle_task_app/utils/theme/custom_themes/icon_button_theme.dart';
import 'package:hudle_task_app/utils/theme/custom_themes/text_theme.dart';

class AppTheme {
  AppTheme._();
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: const Color(0xFFFF5593),
    textTheme: AppTextTheme.lightTextTheme,
    chipTheme: AppChipTheme.lightChipTheme,
    scaffoldBackgroundColor: Color(0xFFF2F2F2),
    appBarTheme: AppAppBarTheme.lightAppBarTheme,
    toggleButtonsTheme: ApptoggleButtonsTheme.lightToggleButtonsTheme,
    checkboxTheme: AppCheckboxTheme.lightCheckboxTheme,
    iconButtonTheme: AppIconButtonTheme.lightIconButtonTheme,
    bottomSheetTheme: AppBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: AppElevatedButtonTheme.lightElevatedButtonTheme,
    textButtonTheme: AppTextButtonTheme.lightTextButtonTheme,
    outlinedButtonTheme: AppOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: AppFormFieldTheme.lightFormFieldTheme,
    switchTheme: AppSwitchTheme.lightSwitchTheme,
    datePickerTheme: AppDatePickerTheme.lightDatePickerTheme,
    sliderTheme: AppSliderTheme.lightSliderTheme,
    floatingActionButtonTheme:
        AppFloatingActionButtonTheme.lightFloatingActionButtonTheme,
    progressIndicatorTheme: ProgressIndicatorThemeData(
      strokeWidth: 1.2,
      strokeCap: StrokeCap.round,
      color: SColors.primary,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.black,
      selectionColor: Colors.black.withAlpha(50),
      selectionHandleColor: Colors.black,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: const Color(0xFFFF5593),
    textTheme: AppTextTheme.darkTextTheme,
    chipTheme: AppChipTheme.darkChipTheme,
    scaffoldBackgroundColor: const Color(0xFF000000),
    appBarTheme: AppAppBarTheme.darkAppBarTheme,
    toggleButtonsTheme: ApptoggleButtonsTheme.darkToggleButtonsTheme,
    checkboxTheme: AppCheckboxTheme.darkCheckboxTheme,
    iconButtonTheme: AppIconButtonTheme.darkIconButtonTheme,
    bottomSheetTheme: AppBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: AppElevatedButtonTheme.darkElevatedButtonTheme,
    textButtonTheme: AppTextButtonTheme.darkTextButtonTheme,
    outlinedButtonTheme: AppOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: AppFormFieldTheme.darkFormFieldTheme,
    switchTheme: AppSwitchTheme.darkSwitchTheme,
    datePickerTheme: AppDatePickerTheme.darkDatePickerTheme,
    sliderTheme: AppSliderTheme.darkSliderTheme,
    floatingActionButtonTheme:
        AppFloatingActionButtonTheme.darkFloatingActionButtonTheme,
    progressIndicatorTheme: ProgressIndicatorThemeData(
      strokeWidth: 1.2,
      strokeCap: StrokeCap.round,
      color: SColors.primary,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.white,
      selectionColor: Colors.white.withAlpha(50),
      selectionHandleColor: Colors.white,
    ),
  );
}
