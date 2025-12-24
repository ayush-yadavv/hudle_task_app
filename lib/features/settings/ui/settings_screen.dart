import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hudle_task_app/coman/widgets/custom_sliver_app_bar.dart';
import 'package:hudle_task_app/coman/widgets/list_section.dart';
import 'package:hudle_task_app/coman/widgets/settings_menu_tile.dart';
import 'package:hudle_task_app/features/settings/bloc/settings_bloc.dart';
import 'package:hudle_task_app/features/settings/bloc/settings_event.dart';
import 'package:hudle_task_app/features/settings/bloc/settings_state.dart';
import 'package:hudle_task_app/features/settings/ui/widgets/settings_footer.dart';
import 'package:hudle_task_app/utils/constants/app_enums.dart';
import 'package:hudle_task_app/utils/constants/colors.dart';
import 'package:hudle_task_app/utils/constants/sizes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            const ASliverAppBar(title: 'Settings', implyLeading: true),
          ],
          body: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: SColors.primary),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Theme Mode Section
                    ListSection(
                      sectionHeading: 'Appearance',
                      children: [
                        RadioGroup<AppThemeMode>(
                          groupValue: state.settings.themeMode,
                          onChanged: (value) {
                            if (value != null) {
                              context.read<SettingsBloc>().add(
                                UpdateThemeMode(value),
                              );
                            }
                          },
                          child: Column(
                            children: [
                              SettingMenuTile(
                                title: AppThemeMode.system.label,
                                trailing: Radio.adaptive(
                                  value: AppThemeMode.system,
                                ),
                                onTap: () => context.read<SettingsBloc>().add(
                                  UpdateThemeMode(AppThemeMode.system),
                                ),
                              ),
                              const SizedBox(height: 2),
                              SettingMenuTile(
                                title: AppThemeMode.light.label,
                                trailing: Radio.adaptive(
                                  value: AppThemeMode.light,
                                ),
                                onTap: () => context.read<SettingsBloc>().add(
                                  UpdateThemeMode(AppThemeMode.light),
                                ),
                              ),
                              const SizedBox(height: 2),
                              SettingMenuTile(
                                title: AppThemeMode.dark.label,
                                trailing: Radio.adaptive(
                                  value: AppThemeMode.dark,
                                ),
                                onTap: () => context.read<SettingsBloc>().add(
                                  UpdateThemeMode(AppThemeMode.dark),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Temperature Units Section
                    ListSection(
                      sectionHeading: 'Temperature',
                      children: [
                        RadioGroup<TempUnit>(
                          groupValue: state.settings.tempUnit,
                          onChanged: (value) {
                            if (value != null) {
                              context.read<SettingsBloc>().add(
                                UpdateTempUnit(value),
                              );
                            }
                          },
                          child: Column(
                            children: [
                              SettingMenuTile(
                                title: 'Celsius',
                                trailing: Radio.adaptive(
                                  value: TempUnit.celsius,
                                ),
                                onTap: () => context.read<SettingsBloc>().add(
                                  UpdateTempUnit(TempUnit.celsius),
                                ),
                              ),
                              const SizedBox(height: 2),
                              SettingMenuTile(
                                title: 'Fahrenheit',
                                trailing: Radio.adaptive(
                                  value: TempUnit.fahrenheit,
                                ),
                                onTap: () => context.read<SettingsBloc>().add(
                                  UpdateTempUnit(TempUnit.fahrenheit),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ListSection(
                      sectionHeading: 'Wind Speed',
                      children: [
                        RadioGroup<WindSpeedUnit>(
                          groupValue: state.settings.windSpeedUnit,
                          onChanged: (value) {
                            if (value != null) {
                              context.read<SettingsBloc>().add(
                                UpdateWindSpeedUnit(value),
                              );
                            }
                          },
                          child: Column(
                            children: [
                              SettingMenuTile(
                                title: WindSpeedUnit.kmh.symbol,
                                trailing: Radio.adaptive(
                                  value: WindSpeedUnit.kmh,
                                ),
                                onTap: () => context.read<SettingsBloc>().add(
                                  UpdateWindSpeedUnit(WindSpeedUnit.kmh),
                                ),
                              ),
                              const SizedBox(height: 2),
                              SettingMenuTile(
                                title: WindSpeedUnit.mps.symbol,
                                trailing: Radio.adaptive(
                                  value: WindSpeedUnit.mps,
                                ),
                                onTap: () => context.read<SettingsBloc>().add(
                                  UpdateWindSpeedUnit(WindSpeedUnit.mps),
                                ),
                              ),
                              const SizedBox(height: 2),
                              SettingMenuTile(
                                title: WindSpeedUnit.mph.symbol,
                                trailing: Radio.adaptive(
                                  value: WindSpeedUnit.mph,
                                ),
                                onTap: () => context.read<SettingsBloc>().add(
                                  UpdateWindSpeedUnit(WindSpeedUnit.mph),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ListSection(
                      sectionHeading: 'Pressure',
                      children: [
                        RadioGroup<PressureUnit>(
                          groupValue: state.settings.pressureUnit,
                          onChanged: (value) {
                            if (value != null) {
                              context.read<SettingsBloc>().add(
                                UpdatePressureUnit(value),
                              );
                            }
                          },
                          child: Column(
                            children: [
                              SettingMenuTile(
                                title: PressureUnit.hpa.symbol,
                                trailing: Radio.adaptive(
                                  value: PressureUnit.hpa,
                                ),
                                onTap: () => context.read<SettingsBloc>().add(
                                  UpdatePressureUnit(PressureUnit.hpa),
                                ),
                              ),
                              const SizedBox(height: 2),
                              SettingMenuTile(
                                title: PressureUnit.inHg.symbol,
                                trailing: Radio.adaptive(
                                  value: PressureUnit.inHg,
                                ),
                                onTap: () => context.read<SettingsBloc>().add(
                                  UpdatePressureUnit(PressureUnit.inHg),
                                ),
                              ),
                              const SizedBox(height: 2),
                              SettingMenuTile(
                                title: PressureUnit.mb.symbol,
                                trailing: Radio.adaptive(
                                  value: PressureUnit.mb,
                                ),
                                onTap: () => context.read<SettingsBloc>().add(
                                  UpdatePressureUnit(PressureUnit.mb),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Sizes.spaceBtwSections),
                    const SettingsFooter(),
                    const SizedBox(height: Sizes.spaceBtwSections),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
