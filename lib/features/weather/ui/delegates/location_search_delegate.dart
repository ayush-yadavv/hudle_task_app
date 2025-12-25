import 'package:flutter/material.dart';
import 'package:hudle_task_app/domain/models/location_data_model/location_model.dart';
import 'package:hudle_task_app/features/weather/bloc/weather_bloc.dart';
import 'package:hudle_task_app/features/weather/ui/widgets/search_history_list.dart';
import 'package:hudle_task_app/features/weather/ui/widgets/search_results_list.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

/// Delegate for location search functionality within a [SearchPage].
class LocationSearchDelegate extends SearchDelegate<LocationModel?> {
  /// The BLoC used to trigger search and history events.
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
        weatherBloc.add(LocationSearchResultEvent(null));
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) return const SizedBox.shrink();

    weatherBloc.add(SearchLocationsEvent(query));

    return SearchResultsList(
      weatherBloc: weatherBloc,
      onLocationSelected: (location) {
        weatherBloc.add(LocationSearchResultEvent(location));
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      weatherBloc.add(LoadSearchHistoryEvent());
      return SearchHistoryList(
        weatherBloc: weatherBloc,
        onLocationSelected: (location) {
          weatherBloc.add(LocationSearchResultEvent(location));
          close(context, null);
        },
      );
    } else {
      weatherBloc.add(SearchLocationsEvent(query));
      return SearchResultsList(
        weatherBloc: weatherBloc,
        onLocationSelected: (location) {
          weatherBloc.add(LocationSearchResultEvent(location));
          close(context, null);
        },
      );
    }
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);

    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        iconTheme: theme.iconTheme,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),
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
