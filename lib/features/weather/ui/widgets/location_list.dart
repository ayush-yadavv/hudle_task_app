import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hudle_task_app/coman/widgets/list_section.dart';
import 'package:hudle_task_app/domain/models/location_data_model/location_model.dart';
import 'package:hudle_task_app/features/weather/bloc/weather_bloc.dart';
import 'package:hudle_task_app/features/weather/ui/widgets/location_menu_tile.dart';
import 'package:hudle_task_app/utils/constants/sizes.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

/// Optimized widget to display a list of locations.
///
/// Uses lazy loading and optimized selection checks to ensure smooth performance.
class LocationList extends StatelessWidget {
  const LocationList({
    super.key,
    required this.locations,
    required this.onLocationSelected,
  });

  final List<LocationModel> locations;
  final Function(LocationModel) onLocationSelected;

  @override
  Widget build(BuildContext context) {
    if (locations.isEmpty) {
      return const _EmptyState();
    }

    // Pull selection criteria out of the builder to avoid repeated Bloc lookups
    final bloc = context.read<WeatherBloc>();
    final currentWeather = bloc.currentWeather;
    final lastSelectedCity = bloc.lastSelectedCity?.toLowerCase();

    // Cache coordinates for faster comparison
    final currentLat = currentWeather?.latitude;
    final currentLon = currentWeather?.longitude;

    return ListSection(
      sectionHeading: 'Recent',
      itemCount: locations.length,
      itemBuilder: (context, index) {
        final location = locations[index];

        // Optimized selection check
        final isSelected = _checkSelection(
          location,
          currentLat,
          currentLon,
          lastSelectedCity,
          currentWeather?.geolocationName,
        );

        final isLast = index == locations.length - 1;

        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 2),
          child: LocationMenuTile(
            location: location,
            isSelected: isSelected,
            showRemoveIcon: true,
            onRemove: () => bloc.add(RemoveFromHistoryEvent(location)),
            onTap: () => onLocationSelected(location),
          ),
        );
      },
    );
  }

  bool _checkSelection(
    LocationModel location,
    double? currentLat,
    double? currentLon,
    String? lastSelectedCity,
    String? currentGeolocationName,
  ) {
    // 1. Check coordinates first for high precision
    if (currentLat != null && currentLon != null) {
      final isCoordMatch =
          (location.lat - currentLat).abs() < 0.0001 &&
          (location.lon - currentLon).abs() < 0.0001;
      if (isCoordMatch) return true;
    }

    // 2. Fallback to name matching
    // If we have a user-friendly name (geolocationName) in current weather, use that.
    // Otherwise fallback to whatever name triggered the fetch.
    if (currentGeolocationName != null && location.name != null) {
      if (currentGeolocationName.toLowerCase() ==
          location.name!.toLowerCase()) {
        return true;
      }
    }

    // 3. Final fallback: raw string match against persistence
    return lastSelectedCity != null &&
        location.name != null &&
        location.name!.toLowerCase() == lastSelectedCity;
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Iconsax.location_cross_copy, size: Sizes.iconLg),
          SizedBox(height: Sizes.spaceBtwInputFields),
          Text('No location history'),
        ],
      ),
    );
  }
}
