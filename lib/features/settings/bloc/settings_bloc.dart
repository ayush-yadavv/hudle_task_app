import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hudle_task_app/data/repository/settings_repository.dart';
import 'package:hudle_task_app/domain/models/settings_model.dart';

import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _settingsRepository;

  SettingsBloc({required SettingsRepository settingsRepository})
    : _settingsRepository = settingsRepository,
      super(SettingsState(settings: SettingsModel())) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateTempUnit>(_onUpdateTempUnit);
    on<UpdateWindSpeedUnit>(_onUpdateWindSpeedUnit);
    on<UpdatePressureUnit>(_onUpdatePressureUnit);
    on<UpdateThemeMode>(_onUpdateThemeMode);
  }

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final settings = _settingsRepository.getSettings();
    emit(state.copyWith(settings: settings, isLoading: false));
  }

  Future<void> _onUpdateTempUnit(
    UpdateTempUnit event,
    Emitter<SettingsState> emit,
  ) async {
    final updatedSettings = state.settings.copyWith(tempUnit: event.unit);
    await _settingsRepository.saveSettings(updatedSettings);
    emit(state.copyWith(settings: updatedSettings));
  }

  Future<void> _onUpdateWindSpeedUnit(
    UpdateWindSpeedUnit event,
    Emitter<SettingsState> emit,
  ) async {
    final updatedSettings = state.settings.copyWith(windSpeedUnit: event.unit);
    await _settingsRepository.saveSettings(updatedSettings);
    emit(state.copyWith(settings: updatedSettings));
  }

  Future<void> _onUpdatePressureUnit(
    UpdatePressureUnit event,
    Emitter<SettingsState> emit,
  ) async {
    final updatedSettings = state.settings.copyWith(pressureUnit: event.unit);
    await _settingsRepository.saveSettings(updatedSettings);
    emit(state.copyWith(settings: updatedSettings));
  }

  Future<void> _onUpdateThemeMode(
    UpdateThemeMode event,
    Emitter<SettingsState> emit,
  ) async {
    final updatedSettings = state.settings.copyWith(themeMode: event.themeMode);
    await _settingsRepository.saveSettings(updatedSettings);
    emit(state.copyWith(settings: updatedSettings));
  }
}
