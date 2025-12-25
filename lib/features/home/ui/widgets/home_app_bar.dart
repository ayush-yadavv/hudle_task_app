import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hudle_task_app/features/weather/bloc/weather_bloc.dart';
import 'package:hudle_task_app/utils/formatters/formatters.dart';
import 'package:hudle_task_app/utils/helpers/helper_functions.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: BlocBuilder<WeatherBloc, WeatherState>(
        // Ignore search-related states to prevent showing "Loading..." when navigating back
        buildWhen: (previous, current) =>
            current is! WeatherActionState &&
            current is! LocationSearchLoading &&
            current is! LocationSearchLoaded &&
            current is! SearchHistoryLoaded,
        builder: (context, state) {
          // Check if no location is selected
          final isNoLocation =
              state is NoLocationSelected || state is WeatherInitial;

          // Extract weather and error city name from state
          final weather = switch (state) {
            WeatherLoaded s => s.weather,
            WeatherRefreshing s => s.weather,
            WeatherError s => s.previousWeather,
            _ => null,
          };

          final errorCityName = state is WeatherError ? state.cityName : null;

          // Determine display name
          String displayName;
          String? subtitle;

          if (state is WeatherLoading && state.cityName != null) {
            displayName = state.cityName!;
            subtitle = 'Loading...';
          } else if (errorCityName != null && weather == null) {
            // Case where initial load failed
            displayName = SHelperFunctions.capitalize(errorCityName);
            subtitle = 'Tap to retry';
          } else if (isNoLocation || weather == null) {
            displayName = 'Select Location';
            subtitle = 'Tap to search';
          } else {
            final stationName = weather.stationName ?? 'Unknown';
            final geolocationName = weather.geolocationName;

            if (geolocationName != null &&
                geolocationName.isNotEmpty &&
                geolocationName.toLowerCase() != stationName.toLowerCase()) {
              displayName = '$geolocationName ($stationName)';
            } else {
              displayName = SHelperFunctions.capitalize(stationName);
            }

            subtitle =
                'Last Updated ${Formatters.formatTimestamp(weather.timestamp)}';
          }

          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              context.read<WeatherBloc>().add(NavigateToSearchScreenEvent());
            },
            onDoubleTap: () {
              HapticFeedback.mediumImpact();
              context.read<WeatherBloc>().add(RefreshWeatherEvent());
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  displayName,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(subtitle, style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          );
        },
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Iconsax.menu_1_copy),
        onPressed: () {
          HapticFeedback.selectionClick();
          context.read<WeatherBloc>().add(NavigateToSearchScreenEvent());
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Iconsax.setting_2_copy),
          onPressed: () {
            HapticFeedback.selectionClick();
            context.read<WeatherBloc>().add(NavigateToSettingsScreenEvent());
          },
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
