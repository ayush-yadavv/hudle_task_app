import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppAppBarTheme {
  AppAppBarTheme._();

  static final AppBarTheme lightAppBarTheme = AppBarTheme(
    elevation: 1,
    centerTitle: false,
    scrolledUnderElevation: 2,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    // foregroundColor: Colors.transparent,
    iconTheme: const IconThemeData(color: Colors.black, size: 24),
    actionsIconTheme: const IconThemeData(color: Colors.black, size: 24),
    titleTextStyle: GoogleFonts.playfairDisplay(
      color: Colors.black,
      fontSize: 20.0,
      // fontWeight: FontWeight.w600,
    ).copyWith(fontFamilyFallback: const ['serif']),
  );

  static AppBarTheme darkAppBarTheme = AppBarTheme(
    elevation: 1,
    centerTitle: false,
    scrolledUnderElevation: 2,
    backgroundColor: Colors.transparent,
    // surfaceTintColor: Colors.blue,
    // foregroundColor: Colors.transparent,
    iconTheme: const IconThemeData(color: Colors.white, size: 24),
    actionsIconTheme: const IconThemeData(color: Colors.white, size: 24),
    // titleTextStyle: TextStyle(
    //   fontSize: 18.0,
    //   fontWeight: FontWeight.w600,
    //   color: Colors.white,
    // ),
    titleTextStyle: GoogleFonts.playfairDisplay(
      fontSize: 20.0,
      // fontWeight: FontWeight.w600,
      color: Colors.white,
    ).copyWith(fontFamilyFallback: const ['serif']),
  );
}
