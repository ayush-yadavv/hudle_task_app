import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hudle_task_app/domain/models/location_model.dart';
import 'package:hudle_task_app/features/weather/bloc/weather_bloc.dart';
import 'package:hudle_task_app/utils/constants/sizes.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class LocationSearchDelegate extends SearchDelegate<LocationModel?> {
  final WeatherBloc weatherBloc;

  LocationSearchDelegate({required this.weatherBloc})
    : super(searchFieldLabel: 'Search Location');

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Iconsax.close_circle_copy),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // If the user hits "search", we can trigger a search or just show suggestions
    // Usually, interactive search happens in suggestions.
    // If we want a separate results view (e.g. detailed), we can do it here.
    // For now, we'll reuse the suggestion logic or trigger a specific search.

    if (query.isEmpty) return const SizedBox.shrink();

    // Trigger search if not already suggested (though we usually search on type)
    weatherBloc.add(SearchLocationsEvent(query));

    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      weatherBloc.add(LoadSearchHistoryEvent());
      return _buildHistoryList();
    } else {
      // Debounce could be handled in Bloc or here.
      // For simplicity, we dispatch on every build (which is on every keypress).
      // Ideally, rely on a debouncer or the Bloc's existing debounce if present.
      // Looking at the Bloc, there is no debounce.
      // We should probably add a simple delay or just fire it.
      // Given it's a "proper" implementation request, let's fire it.
      // NOTE: buildSuggestions is called repeatedly.
      // To avoid flood, we can check if query changed significantly or rely on bloc.

      weatherBloc.add(SearchLocationsEvent(query));
      return _buildSearchResults();
    }
  }

  Widget _buildHistoryList() {
    return BlocBuilder<WeatherBloc, WeatherState>(
      bloc: weatherBloc,
      buildWhen: (previous, current) => current is SearchHistoryLoaded,
      builder: (context, state) {
        if (state is SearchHistoryLoaded) {
          if (state.history.isEmpty) {
            return _buildEmptyState('No recent history', Iconsax.clock_copy);
          }
          return ListView.builder(
            itemCount: state.history.length,
            itemBuilder: (context, index) {
              final location = state.history[index];
              return ListTile(
                // leading: const Icon(Iconsax.clock_copy),
                visualDensity: VisualDensity.adaptivePlatformDensity,
                title: Text(location.name ?? 'Unknown'),
                subtitle: Text(location.displayName),
                trailing: Icon(Iconsax.arrow_right_3_copy),
                onTap: () {
                  close(context, location);
                },
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<WeatherBloc, WeatherState>(
      bloc: weatherBloc,
      buildWhen: (previous, current) =>
          current is LocationSearchLoaded ||
          current is LocationSearchLoading ||
          current is WeatherErrorActionState,
      builder: (context, state) {
        if (state is LocationSearchLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LocationSearchLoaded) {
          if (state.locations.isEmpty) {
            return _buildEmptyState(
              'No locations found',
              Iconsax.location_cross_copy,
            );
          }
          return ListView.builder(
            itemCount: state.locations.length,
            itemBuilder: (context, index) {
              final location = state.locations[index];
              return ListTile(
                leading: const Icon(Iconsax.location_copy),
                title: Text(location.name ?? 'Unknown'),
                subtitle: Text(location.displayName),
                visualDensity: VisualDensity.adaptivePlatformDensity,
                trailing: const Icon(Iconsax.arrow_right_3_copy),
                onTap: () {
                  close(context, location);
                },
              );
            },
          );
        } else if (state is WeatherErrorActionState) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmptyState(String msg, IconData icon) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: Sizes.iconLg),
          const SizedBox(height: Sizes.spaceBtwInputFields),
          Text(msg),
        ],
      ),
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    // Customize AppBar to match app design or dark mode
    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        iconTheme: theme.iconTheme,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,

        // hintStyle: TextStyle(color: Colors.grey),
      ),
      // Ensure text contrast
      textTheme: theme.textTheme.copyWith(
        titleLarge: TextStyle(
          color: theme.brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
          fontSize: 18,
        ),
      ),
    );
  }
}
