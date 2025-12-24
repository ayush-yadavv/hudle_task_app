import 'package:flutter/material.dart';

class AppRadioButtonTheme {
  const AppRadioButtonTheme._();

  static final RadioThemeData light = RadioThemeData(
    fillColor: WidgetStateProperty.all(const Color.fromARGB(255, 0, 0, 0)),
    overlayColor: WidgetStateProperty.all(const Color.fromARGB(52, 0, 0, 0)),
    mouseCursor: WidgetStateProperty.all(SystemMouseCursors.click),
    visualDensity: VisualDensity.standard,
  );

  static final RadioThemeData dark = RadioThemeData(
    fillColor: WidgetStateProperty.all(
      const Color.fromARGB(255, 255, 255, 255),
    ),
    overlayColor: WidgetStateProperty.all(
      const Color.fromARGB(52, 255, 255, 255),
    ),
    mouseCursor: WidgetStateProperty.all(SystemMouseCursors.click),
    visualDensity: VisualDensity.standard,
  );
}
