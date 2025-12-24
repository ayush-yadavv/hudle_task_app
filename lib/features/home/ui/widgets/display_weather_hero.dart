import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hudle_task_app/utils/constants/sizes.dart' show Sizes;

/// Comprehensive mapping of OpenWeatherMap icon codes to weather SVG files.
///
/// Icon code format: [condition][day/night]
/// - 01: Clear sky
/// - 02: Few clouds (11-25%)
/// - 03: Scattered clouds (25-50%)
/// - 04: Broken/Overcast clouds (51-100%)
/// - 09: Shower rain (light, intermittent)
/// - 10: Rain (steady rain)
/// - 11: Thunderstorm
/// - 13: Snow
/// - 50: Mist/Fog/Haze/Dust/Sand/Ash/Squall/Tornado
///
/// 'd' suffix = day, 'n' suffix = night
class DisplayWeatherHero extends StatelessWidget {
  const DisplayWeatherHero({super.key, required this.iconCode});
  final String iconCode;

  /// Maps OpenWeatherMap icon codes to appropriate SVG file names.
  /// Based on OpenWeatherMap icon list and condition codes.
  static const Map<String, String> _weatherSvgMap = {
    // ═══════════════════════════════════════════════════════════════════════
    // CLEAR SKY (01)
    // Group 800: Clear sky
    // ═══════════════════════════════════════════════════════════════════════
    '01d': 'clear-day.svg', // Clear sky (day)
    '01n':
        'clear-night.svg', // Clear sky (night) - using clear-night for accuracy
    // ═══════════════════════════════════════════════════════════════════════
    // FEW CLOUDS (02)
    // Group 80x: Few clouds (11-25%)
    // ═══════════════════════════════════════════════════════════════════════
    '02d': 'partly-cloudy-day.svg', // Few clouds (day)
    '02n': 'partly-cloudy-night.svg', // Few clouds (night)
    // ═══════════════════════════════════════════════════════════════════════
    // SCATTERED CLOUDS (03)
    // Group 80x: Scattered clouds (25-50%)
    // ═══════════════════════════════════════════════════════════════════════
    '03d': 'cloudy.svg', // Scattered clouds (day)
    '03n': 'cloudy.svg', // Scattered clouds (night)
    // ═══════════════════════════════════════════════════════════════════════
    // BROKEN CLOUDS (04)
    // Group 80x: Broken clouds (51-84%) / Overcast clouds (85-100%)
    // ═══════════════════════════════════════════════════════════════════════
    '04d': 'overcast-day.svg', // Broken/Overcast clouds (day)
    '04n': 'overcast-night.svg', // Broken/Overcast clouds (night)
    // ═══════════════════════════════════════════════════════════════════════
    // SHOWER RAIN (09)
    // Group 3xx: Drizzle
    // Group 5xx: Shower Rain (Light intensity, Ragged, etc)
    // ═══════════════════════════════════════════════════════════════════════
    '09d': 'partly-cloudy-day-rain.svg', // Shower rain (day) - sun + rain
    '09n': 'partly-cloudy-night-rain.svg', // Shower rain (night)
    // ═══════════════════════════════════════════════════════════════════════
    // RAIN (10)
    // Group 5xx: Rain (Moderate, Heavy, Very heavy, Extreme)
    // ═══════════════════════════════════════════════════════════════════════
    '10d': 'overcast-day-rain.svg', // Rain (day) - steady/heavy
    '10n': 'overcast-night-rain.svg', // Rain (night)
    // ═══════════════════════════════════════════════════════════════════════
    // THUNDERSTORM (11)
    // Group 2xx: Thunderstorm (Light, Rain, Heavy, Ragged, Drizzle)
    // ═══════════════════════════════════════════════════════════════════════
    '11d': 'thunderstorms-day-rain.svg', // Thunderstorm (day)
    '11n': 'thunderstorms-night-rain.svg', // Thunderstorm (night)
    // ═══════════════════════════════════════════════════════════════════════
    // SNOW (13)
    // Group 6xx: Snow (Light, Heavy, Sleet, Rain and Snow)
    // Group 5xx: Freezing Rain (511)
    // ═══════════════════════════════════════════════════════════════════════
    '13d': 'overcast-day-snow.svg', // Snow (day)
    '13n': 'overcast-night-snow.svg', // Snow (night)
    // ═══════════════════════════════════════════════════════════════════════
    // MIST (50)
    // Group 7xx: Mist, Smoke, Haze, Dust, Fog, Sand, Ash, Squall, Tornado
    // ═══════════════════════════════════════════════════════════════════════
    '50d': 'fog-day.svg', // Mist/Fog (day)
    '50n': 'fog-night.svg', // Mist/Fog (night)
  };

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final String? svgFile = _weatherSvgMap[iconCode];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (svgFile == null) {
          return _buildImageFromApi(constraints);
        }

        return Container(
          padding: const EdgeInsets.all(Sizes.md),
          child: SvgPicture.asset(
            'assets/weather_svg/$svgFile',
            width: constraints.maxWidth * 0.5,
            height: constraints.maxHeight * 0.5,

            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(
              isDarkMode ? Colors.white : Colors.black,
              BlendMode.srcIn,
            ),
            placeholderBuilder: (context) =>
                const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }

  CachedNetworkImage _buildImageFromApi(BoxConstraints constraints) {
    return CachedNetworkImage(
      imageUrl: 'https://openweathermap.org/img/wn/$iconCode@4x.png',
      width: constraints.maxWidth * 0.5,
      height: constraints.maxHeight * 0.5,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 40, color: Colors.white70),
            const SizedBox(height: Sizes.sm),
            Flexible(
              child: Text(
                'Failed to load image',
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
