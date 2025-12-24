import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hudle_task_app/coman/widgets/refresh_indicator_banner.dart';
import 'package:hudle_task_app/coman/widgets/rounded_weather_detail_card.dart';
import 'package:hudle_task_app/coman/widgets/sticky_header_delegate.dart';
import 'package:hudle_task_app/coman/widgets/weather_detail_card.dart';
import 'package:hudle_task_app/features/home/ui/widgets/display_weather_hero.dart';
import 'package:hudle_task_app/features/home/ui/widgets/home_app_bar.dart';
import 'package:hudle_task_app/features/home/ui/widgets/home_shimmer_loader.dart';
import 'package:hudle_task_app/features/home/ui/widgets/temperature_detail_layout.dart';
import 'package:hudle_task_app/features/settings/bloc/settings_bloc.dart';
import 'package:hudle_task_app/features/weather/bloc/weather_bloc.dart';
import 'package:hudle_task_app/utils/constants/colors.dart';
import 'package:hudle_task_app/utils/constants/sizes.dart';
import 'package:hudle_task_app/utils/formatters/formatters.dart';
import 'package:hudle_task_app/utils/helpers/helper_functions.dart';
import 'package:hudle_task_app/utils/loaders/loaders.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch initial weather with current settings
    context.read<WeatherBloc>().add(FetchWeatherByCityEvent('Delhi'));
  }

  @override
  Widget build(BuildContext context) {
    // Watch settings for unit changes
    final settingsState = context.watch<SettingsBloc>().state;
    final settings = settingsState.settings;

    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        appBar: const HomeAppBar(),
        body: BlocConsumer<WeatherBloc, WeatherState>(
          buildWhen: (previous, current) => current is! WeatherActionState,
          listenWhen: (previous, current) => current is WeatherActionState,
          listener: (context, state) {
            if (state is WeatherErrorActionState) {
              SLoader.errorSnackBar(context, message: state.message);
            } else if (state is WeatherLoadingActionState) {
              SLoader.loading(context, loadingText: state.message);
            } else if (state is WeatherLoadingCompleteActionState) {
              SLoader.stopLoading(context);
            }
          },
          builder: (context, state) {
            if (state is WeatherLoading || settingsState.isLoading) {
              return const HomeShimmerLoader();
            }

            if (state is WeatherError &&
                context.read<WeatherBloc>().currentWeather == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Iconsax.warning_2_copy,
                      color: SColors.error,
                      size: 48,
                    ),
                    Text(state.message),
                    ElevatedButton(
                      onPressed: () {
                        context.read<WeatherBloc>().add(
                          FetchWeatherByCityEvent('Noida'),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            // Check if we're in refreshing state
            final isRefreshing = state is WeatherRefreshing;

            // Get weather from state or bloc
            final weather = isRefreshing
                ? state.weather
                : context.read<WeatherBloc>().currentWeather;

            if (weather == null) {
              return const Center(child: Text('No weather data available'));
            }

            return Column(
              children: [
                // Inline Refresh Indicator Banner
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: isRefreshing
                      ? const RefreshIndicatorBanner(
                          message: 'Updating weather',
                        )
                      : const SizedBox.shrink(),
                ),

                // Temp Detail Layout
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Sizes.spaceFromEdge + 4,
                    0,
                    Sizes.spaceFromEdge + 4,
                    Sizes.spaceFromEdge,
                  ),
                  child: TempDetailLayout(
                    temp: weather.temperature ?? 0.0,
                    unit: settings.tempUnit,
                    detail: weather.description ?? '',
                    minTemp: weather.minTemp ?? 0.0,
                    maxTemp: weather.maxTemp ?? 0.0,
                  ),
                ),

                // Weather Details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Sizes.spaceFromEdge,
                      0,
                      Sizes.spaceFromEdge,
                      0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Sizes.borderRadiusXl),
                        topRight: Radius.circular(Sizes.borderRadiusXl),
                      ),

                      // Pull-to-refresh with styled indicator
                      child: RefreshIndicator(
                        displacement: 4,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        onRefresh: () async {
                          if (!isRefreshing) {
                            context.read<WeatherBloc>().add(
                              RefreshWeatherEvent(),
                            );
                            // Wait for refresh to complete
                            await context.read<WeatherBloc>().stream.firstWhere(
                              (state) =>
                                  state is WeatherLoaded ||
                                  state is WeatherError,
                            );
                          }
                        },
                        // custom scroll view
                        child: CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            // sticky header
                            SliverPersistentHeader(
                              floating: false,
                              delegate: StickyHeaderDelegate(
                                minHeight: 0,
                                maxHeight: 250,

                                // Hero widget
                                child: DisplayWeatherHero(
                                  iconCode: weather.iconCode ?? '',
                                ),
                              ),
                            ),

                            // weather details grid
                            SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    crossAxisSpacing: 4,
                                    mainAxisSpacing: 4,
                                    childAspectRatio: 1,
                                  ),
                              delegate: SliverChildListDelegate([
                                WeatherDetailCard(
                                  backgroundColor:
                                      SHelperFunctions.getHumidityColor(
                                        weather.humidity,
                                      ),
                                  headline: 'Humidity',
                                  description: weather.humidity != null
                                      ? '${weather.humidity}%'
                                      : 'N/A',
                                ),
                                RoundedWeatherDetailCard(
                                  backgroundColor:
                                      SHelperFunctions.getTemperatureColor(
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
                                  headline: 'Wind Speed',
                                  description: weather.windSpeed != null
                                      ? Formatters.formatWindSpeed(
                                          weather.windSpeed!,
                                          settings.windSpeedUnit,
                                        )
                                      : 'N/A',
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
                                  backgroundColor:
                                      SHelperFunctions.getSunEventColor(
                                        weather.sunrise,
                                        Colors.orange,
                                      ),
                                  headline: 'Sunrise',
                                  description: weather.sunrise != null
                                      ? Formatters.formatTimestamp(
                                          weather.sunrise!,
                                        )
                                      : 'N/A',
                                ),
                                WeatherDetailCard(
                                  backgroundColor:
                                      SHelperFunctions.getSunEventColor(
                                        weather.sunset,
                                        Colors.indigo,
                                      ),
                                  headline: 'Sunset',
                                  description: weather.sunset != null
                                      ? Formatters.formatTimestamp(
                                          weather.sunset!,
                                        )
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
                            const SliverToBoxAdapter(
                              child: SizedBox(height: Sizes.defaultSpace * 1.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
