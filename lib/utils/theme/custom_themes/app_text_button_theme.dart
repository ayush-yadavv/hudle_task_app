import 'package:flutter/material.dart';

class AppTextButtonTheme {
  AppTextButtonTheme._();

  static final lightTextButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.zero,
      textStyle: const TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),

      // backgroundColor: SColors.primary,
      disabledForegroundColor: Colors.grey,
      disabledBackgroundColor: Colors.grey[300],
      side: const BorderSide(color: Colors.transparent),
      // padding: const EdgeInsets.symmetric(vertical: 18),
      // textStyle: const TextStyle(
      //   fontSize: 16,
      //   color: Colors.white,
      //   fontWeight: FontWeight.w600,
      // ),
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  static final darkTextButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      elevation: 0,
      foregroundColor: Colors.white,
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.zero,
      textStyle: const TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      // foregroundColor: Colors.white,
      // backgroundColor: SColors.primary,
      // disabledForegroundColor: Colors.grey,
      // disabledBackgroundColor: Colors.grey[300],
      tapTargetSize: MaterialTapTargetSize.padded,

      side: const BorderSide(color: Colors.transparent),
      // padding: const EdgeInsets.all(0),
      // textStyle: const TextStyle(
      //   fontSize: 16,
      //   color: Colors.white,
      //   fontWeight: FontWeight.w600,
      // ),
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
