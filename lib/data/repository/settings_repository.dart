import 'package:hive_flutter/hive_flutter.dart';
import 'package:hudle_task_app/domain/models/settings_data_model/settings_model.dart';
import 'package:hudle_task_app/utils/logger/logger.dart';

/// Repository class responsible for managing user settings persistence using Hive.
class SettingsRepository {
  static const String _boxName = 'settingsBox';
  static const String _settingsKey = 'userSettings';

  /// Initializes the Hive box for settings.
  /// Must be called before any other methods.
  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<SettingsModel>(_boxName);
    }
    TLogger.info('SettingsRepository initialized');
  }

  /// Retrieves the current [SettingsModel] from storage.
  /// Returns a default [SettingsModel] if no settings are found.
  SettingsModel getSettings() {
    final box = Hive.box<SettingsModel>(_boxName);
    TLogger.debug('Fetching settings from storage');
    return box.get(_settingsKey) ?? SettingsModel();
  }

  /// Persists the provided [SettingsModel] to storage.
  Future<void> saveSettings(SettingsModel settings) async {
    TLogger.info('Saving settings to storage');
    final box = Hive.box<SettingsModel>(_boxName);
    await box.put(_settingsKey, settings);
  }
}
