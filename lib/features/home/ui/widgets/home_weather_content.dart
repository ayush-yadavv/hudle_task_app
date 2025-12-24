import 'package:flutter/material.dart';
import 'package:hudle_task_app/coman/widgets/rounded_weather_detail_card.dart';
import 'package:hudle_task_app/coman/widgets/sticky_header_delegate.dart';
import 'package:hudle_task_app/coman/widgets/weather_detail_card.dart';
import 'package:hudle_task_app/domain/models/settings_model.dart';
import 'package:hudle_task_app/domain/models/weather_model.dart';
import 'package:hudle_task_app/features/home/ui/widgets/display_weather_hero.dart';
import 'package:hudle_task_app/utils/constants/sizes.dart';
import 'package:hudle_task_app/utils/formatters/formatters.dart';
import 'package:hudle_task_app/utils/helpers/helper_functions.dart';

class HomeWeatherContent extends StatelessWidget {
  final WeatherModel weather;
  final SettingsModel settings;

  const HomeWeatherContent({
    super.key,
    required this.weather,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        // Sticky header with weather hero
        SliverPersistentHeader(
          floating: false,
          delegate: StickyHeaderDelegate(
            minHeight: 0,
            maxHeight: 250,
            child: DisplayWeatherHero(iconCode: weather.iconCode ?? ''),
          ),
        ),

        // Weather details grid
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 1,
          ),
          delegate: SliverChildListDelegate([
            WeatherDetailCard(
              backgroundColor: SHelperFunctions.getHumidityColor(
                weather.humidity,
              ),
              headline: 'Humidity',
              description: weather.humidity != null
                  ? '${weather.humidity}%'
                  : 'N/A',
            ),
            RoundedWeatherDetailCard(
              backgroundColor: SHelperFunctions.getTemperatureColor(
                weather.feelsLike,
              ),
              headline: 'Feels Like',
              isPrimary: true,
              data: Formatters.formatTemp(
                weather.feelsLike ?? 0.0,
                settings.tempUnit,
              ),
            ),
            WeatherDetailCard(
              headline: 'Wind',
              description: Formatters.formatWindInfo(
                weather.windSpeed,
                weather.windDeg,
                settings.windSpeedUnit,
              ),
            ),
            WeatherDetailCard(
              headline: 'Visibility',
              description: weather.visibility != null
                  ? '${((weather.visibility!) / 1000).toStringAsFixed(1)} km'
                  : 'N/A',
            ),
            WeatherDetailCard(
              headline: 'Pressure',
              description: weather.pressure != null
                  ? Formatters.formatPressure(
                      weather.pressure!,
                      settings.pressureUnit,
                    )
                  : 'N/A',
            ),
            WeatherDetailCard(
              headline: 'Cloudiness',
              description: (weather.cloudiness != null)
                  ? '${weather.cloudiness}%'
                  : 'N/A',
            ),
            WeatherDetailCard(
              backgroundColor: SHelperFunctions.getSunEventColor(
                weather.sunrise,
                Colors.orange,
              ),
              headline: 'Sunrise',
              description: weather.sunrise != null
                  ? Formatters.formatTimestamp(weather.sunrise!)
                  : 'N/A',
            ),
            WeatherDetailCard(
              backgroundColor: SHelperFunctions.getSunEventColor(
                weather.sunset,
                Colors.indigo,
              ),
              headline: 'Sunset',
              description: weather.sunset != null
                  ? Formatters.formatTimestamp(weather.sunset!)
                  : 'N/A',
            ),
            WeatherDetailCard(
              headline: 'Sea Level Pressure',
              description: (weather.seaLevel != null)
                  ? Formatters.formatPressure(
                      weather.seaLevel!,
                      settings.pressureUnit,
                    )
                  : 'N/A',
            ),
            WeatherDetailCard(
              headline: 'Ground Level Pressure',
              description: (weather.grndLevel != null)
                  ? Formatters.formatPressure(
                      weather.grndLevel!,
                      settings.pressureUnit,
                    )
                  : 'N/A',
            ),
          ]),
        ),

        // Bottom spacing
        const SliverToBoxAdapter(
          child: SizedBox(height: Sizes.defaultSpace * 2),
        ),
      ],
    );
  }
}
