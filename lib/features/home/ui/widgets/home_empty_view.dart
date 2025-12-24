import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hudle_task_app/features/weather/ui/search_location_screen.dart';
import 'package:hudle_task_app/utils/constants/sizes.dart';
import 'package:hudle_task_app/utils/helpers/helper_functions.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class HomeEmptyView extends StatelessWidget {
  const HomeEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Iconsax.location_copy, color: Colors.blueAccent, size: 64),
          const SizedBox(height: Sizes.md),
          const Text('No Location Selected'),
          const SizedBox(height: Sizes.sm),
          Text(
            'Search and select a city to view weather',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: Sizes.lg),
          ElevatedButton.icon(
            onPressed: () {
              HapticFeedback.selectionClick();
              SHelperFunctions.navigateToScreenLeftSlide(
                context,
                const SearchLocationScreen(),
              );
            },
            icon: const Icon(Iconsax.search_normal_1_copy),
            label: const Text('Search Location'),
          ),
        ],
      ),
    );
  }
}
