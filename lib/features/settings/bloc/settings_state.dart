import 'package:hudle_task_app/domain/models/settings_data_model/settings_model.dart';

class SettingsState {
  final SettingsModel settings;
  final bool isLoading;

  SettingsState({required this.settings, this.isLoading = false});

  SettingsState copyWith({SettingsModel? settings, bool? isLoading}) {
    return SettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
