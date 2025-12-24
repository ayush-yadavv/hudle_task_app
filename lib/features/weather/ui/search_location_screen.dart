import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hudle_task_app/coman/widgets/custom_sliver_app_bar.dart';
import 'package:hudle_task_app/coman/widgets/list_section.dart';
import 'package:hudle_task_app/coman/widgets/search_container.dart';
import 'package:hudle_task_app/domain/models/location_model.dart';
import 'package:hudle_task_app/features/weather/bloc/weather_bloc.dart';
import 'package:hudle_task_app/features/weather/ui/delegates/location_search_delegate.dart';
import 'package:hudle_task_app/features/weather/ui/widgets/location_menu_tile.dart';
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

  bool _isLocationSelected(LocationModel location, WeatherBloc bloc) {
    final currentWeather = bloc.currentWeather;
    final selectedCity = bloc.lastSelectedCity;

    if (currentWeather != null &&
        currentWeather.latitude != null &&
        currentWeather.longitude != null) {
      // Strict match on coordinates (tolerance of 0.0001 for float precision)
      return (location.lat - currentWeather.latitude!).abs() < 0.0001 &&
          (location.lon - currentWeather.longitude!).abs() < 0.0001;
    }
    // Fallback to name match
    return selectedCity != null &&
        location.name != null &&
        location.name!.toLowerCase() == selectedCity.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            const ASliverAppBar(title: 'Search Location', implyLeading: true),
            SliverToBoxAdapter(
              child: SearchContainer(
                text: 'Search Location',
                onTap: () => _openSearchDelegate(context),
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
              }

              if (state is LocationSearchLoaded) {
                // While we typically rely on the delegate for results,
                // if the state persists, we can show results here too.
                return _buildLocationList(state.locations, isHistory: false);
              }

              if (state is SearchHistoryLoaded) {
                return _buildLocationList(state.history, isHistory: true);
              }

              // Handle other states by ensuring history is loaded or showing a loader
              if (state is WeatherLoaded ||
                  state is WeatherRefreshing ||
                  state is WeatherLoading ||
                  state is WeatherInitial ||
                  state is NoLocationSelected) {
                // Ensure history is loaded if we returned from a search or startup
                if (state is! SearchHistoryLoaded) {
                  // Use addPostFrameCallback to avoid state modification during build
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      context.read<WeatherBloc>().add(LoadSearchHistoryEvent());
                    }
                  });
                  return const Center(child: CircularProgressIndicator());
                }
              }

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

  Future<void> _openSearchDelegate(BuildContext context) async {
    final location = await showSearch(
      context: context,
      delegate: LocationSearchDelegate(
        weatherBloc: context.read<WeatherBloc>(),
      ),
    );

    if (!context.mounted) return;

    if (location != null) {
      context.read<WeatherBloc>().add(
        FetchWeatherByCoordinatesEvent(
          latitude: location.lat,
          longitude: location.lon,
          location: location,
        ),
      );
      Navigator.pop(context);
    } else {
      // Reload history if search was cancelled
      context.read<WeatherBloc>().add(LoadSearchHistoryEvent());
    }
  }

  Widget _buildLocationList(
    List<LocationModel> locations, {
    required bool isHistory,
  }) {
    if (locations.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isHistory
                  ? Iconsax.location_cross_copy
                  : Iconsax.search_status_copy,
              size: Sizes.iconLg,
            ),
            const SizedBox(height: Sizes.spaceBtwInputFields),
            Text(isHistory ? 'No location history' : 'No locations found'),
          ],
        ),
      );
    }

    final bloc = context.read<WeatherBloc>();

    if (isHistory) {
      return SingleChildScrollView(
        child: ListSection(
          sectionHeading: 'Recent',
          itemCount: locations.length,
          itemBuilder: (context, index) {
            final location = locations[index];
            final isSelected = _isLocationSelected(location, bloc);
            final isLast = index == locations.length - 1;

            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 2),
              child: LocationMenuTile(
                location: location,
                isSelected: isSelected,
                showRemoveIcon: true,
                onRemove: () => bloc.add(RemoveFromHistoryEvent(location)),
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

    // For standard search results list (if shown here)
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: locations.length,
      itemBuilder: (context, index) {
        final location = locations[index];
        return LocationMenuTile(
          location: location,
          // Search results are typically not "selected" until clicked
          // But we could highlight if it matches current
          isSelected: _isLocationSelected(location, bloc),
          showRemoveIcon: false,
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
        );
      },
    );
  }
}
