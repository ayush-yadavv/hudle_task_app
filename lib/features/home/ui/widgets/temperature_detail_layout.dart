import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hudle_task_app/utils/constants/app_enums.dart';
import 'package:hudle_task_app/utils/constants/sizes.dart';
import 'package:hudle_task_app/utils/formatters/formatters.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class TempDetailLayout extends StatelessWidget {
  const TempDetailLayout({
    super.key,
    required this.temp,
    required this.unit,
    required this.detail,
    required this.minTemp,
    required this.maxTemp,
  });

  final double temp;
  final TempUnit unit;
  final String detail;
  final double minTemp;
  final double maxTemp;

  @override
  Widget build(BuildContext context) {
    // Helper to get raw converted value without symbol
    double convert(double k) => unit == TempUnit.celsius
        ? Formatters.kelvinToCelsius(k)
        : Formatters.kelvinToFahrenheit(k);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          Formatters.formatTemp(temp, unit),
          style: GoogleFonts.dmSerifDisplay(
            fontSize: Sizes.fontSizeLg * 3,
            fontWeight: FontWeight.bold,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(detail, style: Theme.of(context).textTheme.bodyLarge),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Iconsax.arrow_down_copy,
                  color: Colors.blueAccent,
                  size: Sizes.iconSm,
                ),
                const SizedBox(width: 2),
                Text(
                  convert(minTemp).round().toString(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(width: 4),
                const Icon(
                  Iconsax.arrow_up_3_copy,
                  color: Colors.redAccent,
                  size: Sizes.iconSm,
                ),
                const SizedBox(width: 2),
                Text(
                  convert(maxTemp).round().toString(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
