import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hudle_task_app/features/weather/bloc/weather_bloc.dart';
import 'package:hudle_task_app/utils/constants/colors.dart';
import 'package:hudle_task_app/utils/constants/sizes.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class HomeErrorView extends StatelessWidget {
  final String message;

  const HomeErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Iconsax.warning_2_copy, color: SColors.error, size: 48),
          const SizedBox(height: Sizes.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: Sizes.md),
          ElevatedButton(
            onPressed: () {
              // Use configured default city for retry
              context.read<WeatherBloc>().add(LoadInitialWeatherEvent());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
