import 'package:hive/hive.dart';
import 'package:hudle_task_app/utils/constants/app_enums.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 2)
class SettingsModel extends HiveObject {
  @HiveField(0)
  final int tempUnitIndex;

  @HiveField(1)
  final int windSpeedUnitIndex;

  @HiveField(2)
  final int pressureUnitIndex;

  @HiveField(3)
  final int themeModeIndex;

  SettingsModel({
    this.tempUnitIndex = 0,
    this.windSpeedUnitIndex = 0,
    this.pressureUnitIndex = 0,
    this.themeModeIndex = 0, // Default to system
  });

  TempUnit get tempUnit => TempUnit.values[tempUnitIndex];
  WindSpeedUnit get windSpeedUnit => WindSpeedUnit.values[windSpeedUnitIndex];
  PressureUnit get pressureUnit => PressureUnit.values[pressureUnitIndex];
  AppThemeMode get themeMode => AppThemeMode.values[themeModeIndex];

  SettingsModel copyWith({
    TempUnit? tempUnit,
    WindSpeedUnit? windSpeedUnit,
    PressureUnit? pressureUnit,
    AppThemeMode? themeMode,
  }) {
    return SettingsModel(
      tempUnitIndex: tempUnit?.index ?? tempUnitIndex,
      windSpeedUnitIndex: windSpeedUnit?.index ?? windSpeedUnitIndex,
      pressureUnitIndex: pressureUnit?.index ?? pressureUnitIndex,
      themeModeIndex: themeMode?.index ?? themeModeIndex,
    );
  }
}
