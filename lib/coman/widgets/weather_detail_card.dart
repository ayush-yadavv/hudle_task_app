import 'package:flutter/material.dart';
import 'package:hudle_task_app/utils/constants/colors.dart';
import 'package:hudle_task_app/utils/constants/sizes.dart';

class WeatherDetailCard extends StatelessWidget {
  const WeatherDetailCard({
    super.key,
    this.child,
    required this.headline,
    this.description,
    this.isPrimary = false,
    this.backgroundColor,
  });

  final Widget? child;
  final String headline;
  final String? description;
  final bool isPrimary;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final bgColor =
        backgroundColor ??
        (isPrimary
            ? (isDarkMode ? SColors.white : SColors.darkContainer)
            : (isDarkMode ? SColors.darkContainer : SColors.white));

    final textColor = backgroundColor != null
        ? Colors.white
        : (isPrimary
              ? (isDarkMode ? SColors.black : SColors.white)
              : (isDarkMode ? SColors.white : SColors.black));

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
      ),
      margin: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(Sizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              headline,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: Sizes.fontSizeMd,
                color: textColor,
              ),
            ),
            if (description != null) ...[
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: constraints.maxWidth * 0.15,
                    height: 3,
                    decoration: BoxDecoration(
                      color: textColor.withAlpha(150),
                      borderRadius: BorderRadius.circular(Sizes.borderRadiusSm),
                    ),
                  );
                },
              ),
              Text(
                description!,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: Sizes.fontSizeMd,
                  color: textColor,
                ),
              ),
            ],
            if (child != null) ...[const SizedBox(height: 4), child!],
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
