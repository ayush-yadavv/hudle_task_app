import 'package:hudle_task_app/utils/constants/app_enums.dart';

abstract class SettingsEvent {}

class LoadSettings extends SettingsEvent {}

class UpdateTempUnit extends SettingsEvent {
  final TempUnit unit;
  UpdateTempUnit(this.unit);
}

class UpdateWindSpeedUnit extends SettingsEvent {
  final WindSpeedUnit unit;
  UpdateWindSpeedUnit(this.unit);
}

class UpdatePressureUnit extends SettingsEvent {
  final PressureUnit unit;
  UpdatePressureUnit(this.unit);
}

class UpdateThemeMode extends SettingsEvent {
  final AppThemeMode themeMode;
  UpdateThemeMode(this.themeMode);
}
