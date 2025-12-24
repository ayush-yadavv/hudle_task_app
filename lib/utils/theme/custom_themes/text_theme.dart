import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    // Display - Serif
    displayLarge: GoogleFonts.playfairDisplay(
      fontSize: 57.0,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF212121),
      height: 1.4,
    ).copyWith(fontFamilyFallback: ['serif']),
    displayMedium: GoogleFonts.playfairDisplay(
      fontSize: 45.0,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF212121),
      height: 1.4,
    ),
    displaySmall: GoogleFonts.playfairDisplay(
      fontSize: 36.0,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF212121),
      height: 1.4,
    ),

    // Headline - Serif
    headlineLarge: GoogleFonts.playfairDisplay(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF212121),
      height: 1.4,
    ),
    headlineMedium: GoogleFonts.playfairDisplay(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF212121),
      height: 1.4,
    ),
    headlineSmall: GoogleFonts.playfairDisplay(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF212121),
      height: 1.4,
    ),

    // Title - Serif
    titleLarge: GoogleFonts.playfairDisplay(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF212121),
      height: 1.4,
    ),
    titleMedium: GoogleFonts.playfairDisplay(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF212121),
      height: 1.4,
    ),
    titleSmall: GoogleFonts.playfairDisplay(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: const Color(0xFF212121),
      height: 1.4,
    ),

    // Body - Inter
    bodyLarge: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF212121),
      height: 1.4,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: const Color(0xFF212121),
      height: 1.4,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF212121),
      height: 1.4,
    ),

    // Label - Inter
    labelLarge: GoogleFonts.inter(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: const Color.fromARGB(204, 0, 0, 0),
      height: 1.4,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: const Color.fromARGB(204, 0, 0, 0),
      height: 1.4,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 11.0,
      fontWeight: FontWeight.normal,
      color: const Color.fromARGB(204, 0, 0, 0),
      height: 1.4,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    // Display - Serif
    displayLarge: GoogleFonts.playfairDisplay(
      fontSize: 57.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      height: 1.4,
    ).copyWith(fontFamilyFallback: ['serif']),
    displayMedium: GoogleFonts.playfairDisplay(
      fontSize: 45.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      height: 1.4,
    ),
    displaySmall: GoogleFonts.playfairDisplay(
      fontSize: 36.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      height: 1.4,
    ),

    // Headline - Serif
    headlineLarge: GoogleFonts.playfairDisplay(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      height: 1.4,
    ),
    headlineMedium: GoogleFonts.playfairDisplay(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      height: 1.4,
    ),
    headlineSmall: GoogleFonts.playfairDisplay(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      height: 1.4,
    ),

    // Title - Serif
    titleLarge: GoogleFonts.playfairDisplay(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      height: 1.4,
    ),
    titleMedium: GoogleFonts.playfairDisplay(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
      height: 1.4,
    ),
    titleSmall: GoogleFonts.playfairDisplay(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: Colors.white,
      height: 1.4,
    ),

    // Body - Inter
    bodyLarge: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
      height: 1.4,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: Colors.white,
      height: 1.4,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
      height: 1.4,
    ),

    // Label - Inter
    labelLarge: GoogleFonts.inter(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: const Color.fromARGB(204, 255, 255, 255),
      height: 1.4,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: const Color.fromARGB(204, 255, 255, 255),
      height: 1.4,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 11.0,
      fontWeight: FontWeight.normal,
      color: const Color.fromARGB(204, 255, 255, 255),
      height: 1.4,
    ),
  );
}
