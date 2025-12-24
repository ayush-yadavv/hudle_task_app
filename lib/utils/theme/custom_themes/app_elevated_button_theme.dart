import 'package:flutter/material.dart';

class AppElevatedButtonTheme {
  AppElevatedButtonTheme._();
  static ElevatedButtonThemeData lightElevatedButtonTheme =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,

          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          foregroundColor: const Color(0xFFFFFFFF),
          backgroundColor: const Color(0xFF212121),
          disabledForegroundColor: Colors.grey,
          disabledBackgroundColor: Colors.grey[300],
          iconColor: const Color(0xFFFFFFFF),
          disabledIconColor: Colors.grey,
          side: const BorderSide(color: Colors.transparent),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          iconSize: 16,
          textStyle: const TextStyle(
            fontSize: 16.0,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

  static ElevatedButtonThemeData darkElevatedButtonTheme =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          foregroundColor: const Color(0xFF212121),
          iconColor: const Color(0xFF000000),
          disabledIconColor: Colors.grey,
          iconSize: 16,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          disabledForegroundColor: Colors.grey,
          disabledBackgroundColor: Colors.grey[300],
          side: const BorderSide(color: Colors.transparent),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(
            fontSize: 16.0,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
}
