import 'package:flutter/material.dart';

class AppFloatingActionButtonTheme {
  AppFloatingActionButtonTheme._();

  static final lightFloatingActionButtonTheme = FloatingActionButtonThemeData(
    backgroundColor: const Color.fromARGB(255, 6, 0, 3),
    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
    elevation: 2,
    disabledElevation: 0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(24)),
    ),
    enableFeedback: true,
    iconSize: 24,
    extendedTextStyle: const TextStyle(
      color: Color.fromARGB(255, 255, 255, 255),
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    splashColor: Colors.grey,
  );

  static final darkFloatingActionButtonTheme = FloatingActionButtonThemeData(
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    foregroundColor: const Color.fromARGB(255, 0, 0, 0),
    elevation: 2,
    disabledElevation: 0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(24)),
    ),
    enableFeedback: true,
    iconSize: 24,
    extendedTextStyle: const TextStyle(
      color: Color.fromARGB(255, 0, 0, 0),
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    splashColor: Colors.grey,
  );
}
