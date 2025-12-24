import 'package:hive_flutter/hive_flutter.dart';
import 'package:hudle_task_app/domain/models/settings_model.dart';

/// Repository for handling user settings persistence using Hive
/// Implements the Repository pattern to separate data layer from business logic
class SettingsRepository {
  static const String _boxName = 'settingsBox';
  static const String _settingsKey = 'userSettings';

  /// Initialize the settings box
  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<SettingsModel>(_boxName);
    }
  }

  /// Get current settings from Hive
  SettingsModel getSettings() {
    final box = Hive.box<SettingsModel>(_boxName);
    return box.get(_settingsKey) ?? SettingsModel();
  }

  /// Save settings to Hive
  Future<void> saveSettings(SettingsModel settings) async {
    final box = Hive.box<SettingsModel>(_boxName);
    await box.put(_settingsKey, settings);
  }
}
