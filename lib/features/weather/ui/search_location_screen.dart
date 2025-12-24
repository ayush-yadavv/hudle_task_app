import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hudle_task_app/coman/widgets/custom_sliver_app_bar.dart';
import 'package:hudle_task_app/coman/widgets/list_section.dart';
import 'package:hudle_task_app/coman/widgets/search_container.dart';
import 'package:hudle_task_app/coman/widgets/settings_menu_tile.dart';
import 'package:hudle_task_app/features/weather/bloc/weather_bloc.dart';
import 'package:hudle_task_app/features/weather/ui/delegates/location_search_delegate.dart';
import 'package:hudle_task_app/utils/constants/sizes.dart';
import 'package:hudle_task_app/utils/loaders/loaders.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({super.key});

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  @override
  void initState() {
    super.initState();
    // Load search history
    context.read<WeatherBloc>().add(LoadSearchHistoryEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            ASliverAppBar(title: 'Search Location', implyLeading: true),

            SliverToBoxAdapter(
              child: SearchContainer(
                text: 'Search Location',
                onTap: () async {
                  final location = await showSearch(
                    context: context,
                    delegate: LocationSearchDelegate(
                      weatherBloc: context.read<WeatherBloc>(),
                    ),
                  );

                  if (location != null && context.mounted) {
                    context.read<WeatherBloc>().add(
                      FetchWeatherByCoordinatesEvent(
                        latitude: location.lat,
                        longitude: location.lon,
                        location: location,
                      ),
                    );
                    Navigator.pop(context);
                  } else if (context.mounted) {
                    context.read<WeatherBloc>().add(LoadSearchHistoryEvent());
                  }
                },
              ),
            ),
          ],
          body: BlocConsumer<WeatherBloc, WeatherState>(
            buildWhen: (previous, current) => current is! WeatherActionState,
            listenWhen: (previous, current) => current is WeatherActionState,
            listener: (context, state) {
              if (state is WeatherErrorActionState) {
                SLoader.errorSnackBar(context, message: state.message);
              }
            },
            builder: (context, state) {
              if (state is LocationSearchLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is LocationSearchLoaded) {
                if (state.locations.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Iconsax.location_cross_copy, size: Sizes.iconLg),
                        SizedBox(height: Sizes.spaceBtwInputFields),
                        Text('No locations found'),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: state.locations.length,
                  itemBuilder: (context, index) {
                    final location = state.locations[index];
                    return SettingMenuTile(
                      title: location.name ?? 'Unknown',
                      subTitle: Text(location.displayName),
                      trailing: const Icon(Iconsax.arrow_right_2_copy),
                      onTap: () {
                        context.read<WeatherBloc>().add(
                          FetchWeatherByCoordinatesEvent(
                            latitude: location.lat,
                            longitude: location.lon,
                            location: location,
                          ),
                        );
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              } else if (state is SearchHistoryLoaded) {
                if (state.history.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Iconsax.location_cross_copy, size: Sizes.iconLg),
                        SizedBox(height: Sizes.spaceBtwInputFields),
                        Text('No locations History'),
                      ],
                    ),
                  );
                }
                // Get the currently selected city from the bloc
                final bloc = context.read<WeatherBloc>();
                final selectedCity = bloc.lastSelectedCity;

                // Use ListSection with itemBuilder for lazy building
                return SingleChildScrollView(
                  child: ListSection(
                    sectionHeading: 'Recent',
                    itemCount: state.history.length,
                    itemBuilder: (context, index) {
                      final location = state.history[index];
                      final isLast = index == state.history.length - 1;

                      // Check if this location is currently selected
                      // We prefer strict coordinate matching to avoid duplicates of the same city name being selected
                      final currentWeather = bloc.currentWeather;
                      bool isCurrentlySelected = false;

                      if (currentWeather != null &&
                          currentWeather.latitude != null &&
                          currentWeather.longitude != null) {
                        // Strict match on coordinates (tolerance of 0.0001 for float precision)
                        isCurrentlySelected =
                            (location.lat - currentWeather.latitude!).abs() <
                                0.0001 &&
                            (location.lon - currentWeather.longitude!).abs() <
                                0.0001;
                      } else {
                        // Fallback to name match if weather data isn't fully available
                        isCurrentlySelected =
                            selectedCity != null &&
                            location.name != null &&
                            location.name!.toLowerCase() ==
                                selectedCity.toLowerCase();
                      }

                      return Padding(
                        padding: EdgeInsets.only(bottom: isLast ? 0 : 2),
                        child: SettingMenuTile(
                          isSelected: isCurrentlySelected,
                          title: location.name ?? 'Unknown',
                          subTitle: Text(
                            location.displayName,
                            style: TextStyle(
                              color: isCurrentlySelected ? Colors.white : null,
                            ),
                          ),
                          trailing: isCurrentlySelected
                              ? IgnorePointer(
                                  child: IconButton(
                                    icon: Icon(
                                      Iconsax.tick_circle_copy,
                                      color: Colors.white,
                                      size: Sizes.iconMd,
                                    ),
                                    onPressed: () {},
                                  ),
                                )
                              : IconButton(
                                  icon: const Icon(
                                    Iconsax.close_circle_copy,
                                    size: Sizes.iconMd,
                                  ),
                                  onPressed: () {
                                    bloc.add(RemoveFromHistoryEvent(location));
                                  },
                                ),
                          onTap: () {
                            bloc.add(
                              FetchWeatherByCoordinatesEvent(
                                latitude: location.lat,
                                longitude: location.lon,
                                location: location,
                              ),
                            );
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
                );
              }

              // For any other state (including weather states), load history
              // This handles the case when navigating from home screen
              if (state is WeatherLoaded ||
                  state is WeatherRefreshing ||
                  state is WeatherLoading ||
                  state is WeatherInitial ||
                  state is NoLocationSelected) {
                // Trigger loading history if not already loaded
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.read<WeatherBloc>().add(LoadSearchHistoryEvent());
                });
                return const Center(child: CircularProgressIndicator());
              }

              // Default view (for any unexpected state)
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Iconsax.search_normal_1_copy, size: Sizes.iconLg),
                    SizedBox(height: Sizes.spaceBtwInputFields),
                    Text('Start typing to search...'),
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
