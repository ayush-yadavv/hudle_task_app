import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hudle_task_app/coman/widgets/custom_sliver_app_bar.dart';
import 'package:hudle_task_app/coman/widgets/list_section.dart';
import 'package:hudle_task_app/coman/widgets/settings_menu_tile.dart';
import 'package:hudle_task_app/features/weather/bloc/weather_bloc.dart';
import 'package:hudle_task_app/utils/constants/sizes.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({super.key});

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load search history
    context.read<WeatherBloc>().add(LoadSearchHistoryEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          ASliverAppBar(title: 'Search Location', implyLeading: true),
        ],
        body: Column(
          children: [
            //search bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.spaceFromEdge,
                vertical: Sizes.spaceFromEdge,
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  context.read<WeatherBloc>().add(SearchLocationsEvent(value));
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Sizes.borderRadiusSm),
                  ),
                  hintText: 'Search Location',
                  prefixIcon: const Icon(Iconsax.search_normal_1_copy),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      context.read<WeatherBloc>().add(SearchLocationsEvent(''));
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocConsumer<WeatherBloc, WeatherState>(
                buildWhen: (previous, current) =>
                    current is! WeatherActionState,
                listenWhen: (previous, current) =>
                    current is WeatherActionState,
                listener: (context, state) {
                  if (state is WeatherErrorActionState) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  if (state is LocationSearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is LocationSearchLoaded) {
                    if (state.locations.isEmpty) {
                      return const Center(child: Text('No locations found'));
                    }
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: state.locations.length,
                      itemBuilder: (context, index) {
                        final location = state.locations[index];
                        return SettingMenuTile(
                          title: location.name,
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
                        child: Text('Search for a city to see history'),
                      );
                    }
                    return ListSection(
                      sectionHeading: 'History',
                      children: state.history.map((location) {
                        return SettingMenuTile(
                          title: location.name,
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
                      }).toList(),
                    );
                  }

                  // Default view (loading or initial)
                  return const Center(child: Text('Start typing to search...'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
