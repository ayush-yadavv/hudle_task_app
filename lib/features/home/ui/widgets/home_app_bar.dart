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
        buildWhen: (previous, current) => current is! WeatherActionState,
        builder: (context, state) {
          final weather = context.read<WeatherBloc>().currentWeather;
          final cityName = weather?.cityName ?? 'Noida';
          final lastUpdated = weather != null
              ? 'Last Updated ${Formatters.formatTimestamp(weather.timestamp)}'
              : 'Fetching...';

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                SHelperFunctions.capitalize(cityName),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(lastUpdated, style: Theme.of(context).textTheme.labelSmall),
            ],
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
