import 'package:flutter/material.dart';

class SColors {
  SColors._();

  // App basic colors
  static const Color primary = Color(0xFFE281B1);
  static const Color ctaDark = Color(0xFF990302);
  static const Color ctaLight = Color(0xFF990302);
  static const Color primaryLightAccent = Color.fromARGB(64, 255, 85, 147);
  static const Color primaryDarkAccent = Color.fromARGB(191, 255, 85, 147);
  static const Color primaryAccent = Color.fromARGB(128, 255, 85, 147);
  static const Color secondary = Color.fromARGB(255, 255, 114, 126);
  static const Color accent = Color(0x50E9525F);

  //  Gradients Colors
  static const Gradient linerGradient = LinearGradient(
    begin: Alignment(0, 0),
    end: Alignment(0.707, -0.707),
    colors: [
      Color.fromARGB(255, 255, 123, 118),
      Color.fromARGB(255, 255, 255, 255),
    ],
  );
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment(0, 0),
    end: Alignment(0.707, -0.707),
    colors: [Color(0xFFEF7D85), Color(0xFFE9525F)],
  );

  // text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textWhite = Color(0xFFFFFFFF);

  // background colors
  static const Color light = Color(0xFFE5E5E5);
  static const Color dark = Color(0xFF212121);
  static const Color primarybg = Color(0xFFFFFFFF);

  // background container colors
  static const Color lightContainer = Color(0xFFE2E2E2);
  static final Color darkContainer = Color(0xFF1b1b1b);
  static const Color iconBgContainer = Color.fromARGB(98, 233, 30, 98);

  // button colors
  static const Color buttonPrimary = Color(0xFF3F51B5);
  static const Color buttonSecondary = Color(0xFFE91E63);
  static const Color buttonDisabled = Color(0xFFBDBDBD);

  // border colors
  static const Color borderPrimary = Color(0xFFBDBDBD);
  static const Color borderSecondary = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF424242);

  // Error and validation colors
  static const Color error = Color.fromARGB(127, 211, 47, 47);
  static const Color success = Color(0xFF388E3C);
  static const Color green = Color(0xFF388E3C);
  static const Color warning = Color(0xFFFFA000);
  static const Color info = Color(0xFF1976D2);

  // Neutral colors
  static const Color black = Color(0xFF000000);
  static const Color darkerGrey = Color(0xFF424242);
  static const Color darkGrey = Color(0xFF616161);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color softGrey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFE0E0E0);
  static const Color lighterGrey = Color.fromARGB(255, 236, 236, 236);
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Color(0x00000000);

  //bottemsheet
  static const Color lightBottomSheet = Color(0xFFF2F2F2);
  static const Color darkBottomSheet = Color(0xFF1C1C1C);

  //icons

  static const Color darkcircularProgressIndicatorColor = Colors.white;
  static const Color lightcircularProgressIndicatorColor = Color.fromARGB(
    255,
    44,
    44,
    44,
  );

  //list tiles
  static const Color listTileDark = Color(0xFF1C1C1C);
  static const Color listTileLight = Color(0xFFF2F2F2);

  //bottem nav Bar
  static const Color btmNavBardark = Color(0xFF1C1C1C);
  static const Color btmNavBarLight = Color(0xFFF2F2F2);
}
