import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hudle_task_app/domain/models/location_data_model/location_model.dart';
import 'package:hudle_task_app/features/weather/bloc/weather_bloc.dart';
import 'package:hudle_task_app/features/weather/ui/widgets/search_empty_state.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

/// A widget that displays the list of recently searched locations.
class SearchHistoryList extends StatelessWidget {
  const SearchHistoryList({
    super.key,
    required this.weatherBloc,
    required this.onLocationSelected,
  });

  /// The BLoC used to manage search history states.
  final WeatherBloc weatherBloc;

  /// Callback function triggered when a location is selected from the history list.
  final Function(LocationModel) onLocationSelected;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      bloc: weatherBloc,
      buildWhen: (previous, current) => current is SearchHistoryLoaded,
      builder: (context, state) {
        if (state is SearchHistoryLoaded) {
          if (state.history.isEmpty) {
            return const SearchEmptyState(
              message: 'No recent history',
              icon: Iconsax.clock_copy,
            );
          }
          return ListView.builder(
            itemCount: state.history.length,
            itemBuilder: (context, index) {
              final location = state.history[index];
              return ListTile(
                visualDensity: VisualDensity.adaptivePlatformDensity,
                title: Text(location.name ?? 'Unknown'),
                subtitle: Text(location.displayName),
                trailing: const Icon(Iconsax.arrow_right_3_copy),
                onTap: () => onLocationSelected(location),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
