import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hudle_task_app/domain/models/location_data_model/location_model.dart';
import 'package:hudle_task_app/features/weather/bloc/weather_bloc.dart';
import 'package:hudle_task_app/features/weather/ui/widgets/search_empty_state.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

/// A widget that displays the results of a location search.
class SearchResultsList extends StatelessWidget {
  const SearchResultsList({
    super.key,
    required this.weatherBloc,
    required this.onLocationSelected,
  });

  /// The BLoC used to manage location search states.
  final WeatherBloc weatherBloc;

  /// Callback function triggered when a location is selected from the search results.
  final Function(LocationModel) onLocationSelected;

  @override
  Widget build(BuildContext context) {
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
            return const SearchEmptyState(
              message: 'No locations found',
              icon: Iconsax.location_cross_copy,
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
                onTap: () => onLocationSelected(location),
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
}
