import 'package:flutter/material.dart';

class AppIconButtonTheme {
  AppIconButtonTheme._();

  static final IconButtonThemeData lightIconButtonTheme = IconButtonThemeData(
    style: ButtonStyle(
      // backgroundColor: WidgetStateProperty.all(Colors.white),
      // foregroundColor: WidgetStateProperty.all(Colors.black),
      // overlayColor: WidgetStateProperty.all(Colors.grey.shade200),
      // shape: WidgetStateProperty.all(
      //   RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      // ),
    ),
  );

  static final IconButtonThemeData darkIconButtonTheme = IconButtonThemeData(
    style: ButtonStyle(
      // backgroundColor: WidgetStateProperty.all(Colors.grey.shade800),
      // foregroundColor: WidgetStateProperty.all(Colors.white),
      // overlayColor: WidgetStateProperty.all(Colors.grey.shade700),
    ),
  );
}
