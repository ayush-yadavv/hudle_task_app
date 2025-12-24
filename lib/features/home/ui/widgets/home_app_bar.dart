import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hudle_task_app/features/settings/ui/settings_screen.dart';
import 'package:hudle_task_app/features/weather/bloc/weather_bloc.dart';
import 'package:hudle_task_app/features/weather/ui/search_location_screen.dart';
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

          // Extract weather from state using pattern matching
          final weather = switch (state) {
            WeatherLoaded s => s.weather,
            WeatherRefreshing s => s.weather,
            WeatherError s => s.previousWeather,
            _ => null,
          };

          // Determine display name
          String displayName;
          String? subtitle;

          if (isNoLocation || weather == null) {
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
              SHelperFunctions.navigateToScreenLeftSlide(
                context,
                const SearchLocationScreen(),
              );
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
          SHelperFunctions.navigateToScreenLeftSlide(
            context,
            SearchLocationScreen(),
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Iconsax.setting_2_copy),
          onPressed: () {
            HapticFeedback.selectionClick();
            SHelperFunctions.navigateToScreen(context, SettingsScreen());
          },
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
