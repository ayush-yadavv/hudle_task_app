import 'package:flutter/material.dart';
import 'package:hudle_task_app/utils/constants/colors.dart';

class AppSliderTheme {
  AppSliderTheme._();

  static SliderThemeData lightSliderTheme = SliderThemeData(
    trackHeight: 12,
    valueIndicatorColor: SColors.primaryLightAccent,
    activeTrackColor: SColors.primaryDarkAccent,
    inactiveTrackColor: SColors.primaryLightAccent,
    thumbColor: SColors.black,
    overlayColor: Colors.transparent,
    thumbShape: HandleThumbShape(),
    rangeThumbShape: HandleRangeSliderThumbShape(),
    rangeValueIndicatorShape: const RoundedRectRangeSliderValueIndicatorShape(),
    thumbSize: WidgetStateProperty.all(const Size(6, 36)),
    trackShape: GappedSliderTrackShape(),
    valueIndicatorShape: const RoundedRectSliderValueIndicatorShape(),
    rangeTrackShape: const GappedRangeSliderTrackShape(),
    trackGap: 8,
    valueIndicatorTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
  );

  static SliderThemeData darkSliderTheme = SliderThemeData(
    trackHeight: 12,
    valueIndicatorColor: SColors.primaryLightAccent,
    activeTrackColor: SColors.primaryDarkAccent,
    inactiveTrackColor: SColors.primaryLightAccent,
    thumbColor: SColors.white,
    overlayColor: Colors.transparent,
    valueIndicatorShape: const RoundedRectSliderValueIndicatorShape(),
    thumbShape: HandleThumbShape(),
    rangeThumbShape: HandleRangeSliderThumbShape(),
    thumbSize: WidgetStateProperty.all(const Size(6, 36)),
    trackShape: GappedSliderTrackShape(),
    rangeTrackShape: const GappedRangeSliderTrackShape(),
    rangeValueIndicatorShape: const RoundedRectRangeSliderValueIndicatorShape(),
    trackGap: 8,
    valueIndicatorTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
  );
}
