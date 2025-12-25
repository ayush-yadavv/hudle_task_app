import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hudle_task_app/coman/widgets/custom_sliver_app_bar.dart';
import 'package:hudle_task_app/features/settings/bloc/settings_bloc.dart';
import 'package:hudle_task_app/features/settings/bloc/settings_event.dart';
import 'package:hudle_task_app/features/settings/bloc/settings_state.dart';
import 'package:hudle_task_app/features/settings/ui/widgets/settings_footer.dart';
import 'package:hudle_task_app/features/settings/ui/widgets/settings_radio_section.dart';
import 'package:hudle_task_app/utils/constants/app_enums.dart';
import 'package:hudle_task_app/utils/constants/colors.dart';
import 'package:hudle_task_app/utils/constants/sizes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
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
                    SettingsRadioSection<AppThemeMode>(
                      title: 'Appearance',
                      groupValue: state.settings.themeMode,
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(
                          UpdateThemeMode(value),
                        );
                      },
                      options: [
                        SettingsRadioOption(
                          label: AppThemeMode.system.label,
                          value: AppThemeMode.system,
                        ),
                        SettingsRadioOption(
                          label: AppThemeMode.light.label,
                          value: AppThemeMode.light,
                        ),
                        SettingsRadioOption(
                          label: AppThemeMode.dark.label,
                          value: AppThemeMode.dark,
                        ),
                      ],
                    ),

                    // Temperature Units Section
                    SettingsRadioSection<TempUnit>(
                      title: 'Temperature',
                      groupValue: state.settings.tempUnit,
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(UpdateTempUnit(value));
                      },
                      options: [
                        SettingsRadioOption(
                          label: 'Celsius',
                          value: TempUnit.celsius,
                        ),
                        SettingsRadioOption(
                          label: 'Fahrenheit',
                          value: TempUnit.fahrenheit,
                        ),
                      ],
                    ),

                    // Wind Speed Section
                    SettingsRadioSection<WindSpeedUnit>(
                      title: 'Wind Speed',
                      groupValue: state.settings.windSpeedUnit,
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(
                          UpdateWindSpeedUnit(value),
                        );
                      },
                      options: [
                        SettingsRadioOption(
                          label: WindSpeedUnit.kmh.symbol,
                          value: WindSpeedUnit.kmh,
                        ),
                        SettingsRadioOption(
                          label: WindSpeedUnit.mps.symbol,
                          value: WindSpeedUnit.mps,
                        ),
                        SettingsRadioOption(
                          label: WindSpeedUnit.mph.symbol,
                          value: WindSpeedUnit.mph,
                        ),
                      ],
                    ),

                    // Pressure Section
                    SettingsRadioSection<PressureUnit>(
                      title: 'Pressure',
                      groupValue: state.settings.pressureUnit,
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(
                          UpdatePressureUnit(value),
                        );
                      },
                      options: [
                        SettingsRadioOption(
                          label: PressureUnit.hpa.symbol,
                          value: PressureUnit.hpa,
                        ),
                        SettingsRadioOption(
                          label: PressureUnit.inHg.symbol,
                          value: PressureUnit.inHg,
                        ),
                        SettingsRadioOption(
                          label: PressureUnit.mb.symbol,
                          value: PressureUnit.mb,
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
