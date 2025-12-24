import 'package:flutter/material.dart';
import 'package:hudle_task_app/utils/constants/colors.dart';
import 'package:hudle_task_app/utils/constants/sizes.dart';

class RoundedWeatherDetailCard extends StatelessWidget {
  const RoundedWeatherDetailCard({
    super.key,
    required this.headline,
    this.data,
    this.isPrimary = false,
    this.backgroundColor,
  });

  final String headline;
  final String? data;
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

    //white if bgcolor is not null then white
    final textColor = backgroundColor != null
        ? Colors.white
        : (isPrimary
              ? (isDarkMode ? SColors.black : SColors.white)
              : (isDarkMode ? SColors.white : SColors.black));
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1000)),
      margin: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(Sizes.xl),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (data != null)
                FittedBox(
                  child: Text(
                    data!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: textColor,
                      fontSize: Sizes.fontSizeLg * 2,
                    ),
                  ),
                ),
              const SizedBox(height: 2),
              Text(
                headline,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: textColor.withAlpha(204),
                  fontSize: Sizes.fontSizeMd,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
