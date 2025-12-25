import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hudle_task_app/features/home/ui/widgets/home_app_bar.dart';
import 'package:hudle_task_app/features/home/ui/widgets/home_empty_view.dart';
import 'package:hudle_task_app/features/home/ui/widgets/home_error_view.dart';
import 'package:hudle_task_app/features/home/ui/widgets/home_refresh_wrapper.dart';
import 'package:hudle_task_app/features/home/ui/widgets/home_shimmer_loader.dart';
import 'package:hudle_task_app/features/home/ui/widgets/home_weather_content.dart';
import 'package:hudle_task_app/features/home/ui/widgets/temperature_detail_layout.dart';
import 'package:hudle_task_app/features/settings/bloc/settings_bloc.dart';
import 'package:hudle_task_app/features/settings/ui/settings_screen.dart';
import 'package:hudle_task_app/features/weather/bloc/weather_bloc.dart';
import 'package:hudle_task_app/features/weather/ui/search_location_screen.dart';
import 'package:hudle_task_app/utils/constants/sizes.dart';
import 'package:hudle_task_app/utils/helpers/helper_functions.dart';
import 'package:hudle_task_app/utils/loaders/loaders.dart';

/// The main dashboard of the application displaying current weather information.
///
/// It uses [WeatherBloc] to manage weather states and [SettingsBloc] for user preferences.
/// The screen includes:
/// - A custom app bar ([HomeAppBar]).
/// - Temperature overview ([TempDetailLayout]).
/// - A scrollable grid of weather details ([HomeWeatherContent]) wrapped in a refresh indicator ([HomeRefreshWrapper]).
/// - Shimmer loaders and error views for various states.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Only load initial weather if not already in a weather-displaying state
    final currentState = context.read<WeatherBloc>().state;
    final hasWeatherData =
        currentState is WeatherLoaded ||
        currentState is WeatherRefreshing ||
        (currentState is WeatherError && currentState.previousWeather != null);

    if (!hasWeatherData) {
      context.read<WeatherBloc>().add(LoadInitialWeatherEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch settings for unit changes
    final settingsState = context.watch<SettingsBloc>().state;
    final settings = settingsState.settings;

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        appBar: const HomeAppBar(),
        body: BlocConsumer<WeatherBloc, WeatherState>(
          // Build only for weather UI states
          buildWhen: (previous, current) => current is HomeWeatherState,
          // Listen only for action states (side effects)
          listenWhen: (previous, current) => current is WeatherActionState,
          listener: (context, state) {
            // Handle side effects (snackbars, navigation, etc.)
            if (state is WeatherErrorActionState) {
              SLoader.errorSnackBar(context, message: state.message);
            } else if (state is WeatherLoadingActionState) {
              SLoader.loading(context, loadingText: state.message);
            } else if (state is WeatherLoadingCompleteActionState) {
              SLoader.stopLoading(context);
            } else if (state is NavigateToSearchScreenActionState) {
              SHelperFunctions.navigateToScreenLeftSlide(
                context,
                const SearchLocationScreen(),
              );
            } else if (state is NavigateToSettingsScreenActionState) {
              SHelperFunctions.navigateToScreen(
                context,
                const SettingsScreen(),
              );
            }
          },
          builder: (context, state) {
            // Loading state
            if (state is WeatherLoading || settingsState.isLoading) {
              return const HomeShimmerLoader();
            }

            // No location selected - prompt user to select
            if (state is NoLocationSelected) {
              return const HomeEmptyView();
            }

            // Extract weather from state using pattern matching
            final weather = switch (state) {
              WeatherLoaded s => s.weather,
              WeatherRefreshing s => s.weather,
              WeatherError s => s.previousWeather,
              _ => null,
            };

            // Error state with no previous data to show
            if (state is WeatherError && weather == null) {
              return HomeErrorView(message: state.message);
            }

            if (weather == null) {
              return const HomeEmptyView();
            }

            return Column(
              children: [
                // Temperature Detail Layout (above refresh area)
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

                // Weather Details Grid with Custom Pull-to-Refresh
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.spaceFromEdge,
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(Sizes.borderRadiusXl),
                        topRight: Radius.circular(Sizes.borderRadiusXl),
                      ),
                      child: HomeRefreshWrapper(
                        child: HomeWeatherContent(
                          weather: weather,
                          settings: settings,
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
