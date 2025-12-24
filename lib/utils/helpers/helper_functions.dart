import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hudle_task_app/utils/constants/colors.dart';
import 'package:hudle_task_app/utils/popups/toast_helper.dart';

class SHelperFunctions {
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(context, CupertinoPageRoute(builder: (_) => screen));
  }

  static void navigateToScreenLeftSlide(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  static void navigateToScreenAndReplace(BuildContext context, Widget screen) {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(builder: (_) => screen),
      (route) => false,
    );
  }

  static void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }

  static String truncateText(String text, int length) {
    if (text.length <= length) {
      return text;
    } else {
      return '${text.substring(0, length)}...';
    }
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size screenSize(BuildContext context) {
    return MediaQuery.sizeOf(context);
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  static String capitalize(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

  static void showBottomSheet(BuildContext context, Widget bottomSheet) {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      builder: (context) => bottomSheet,
      isScrollControlled: true,
      barrierColor: SColors.black.withAlpha(25),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? SColors.darkBottomSheet
          : SColors.lightBottomSheet,
    );
  }

  static void copyToClipboard(
    BuildContext context,
    String text,
    String? successMessage,
  ) {
    Clipboard.setData(ClipboardData(text: text));
    if (successMessage != null) {
      SToast.showToast(
        context,
        successMessage,
        // toastLength: Toast.LENGTH_SHORT,
        position: ToastGravity.BOTTOM,
        backgroundColor: SColors.black.withAlpha(200),
        textColor: SColors.white,
      );
    }
  }

  static Color getTemperatureColor(double? kelvin) {
    if (kelvin == null) return SColors.primary;
    final celsius = kelvin - 273.15;
    if (celsius < 10) return Colors.blue.shade700;
    if (celsius < 20) return Colors.cyan.shade600;
    if (celsius < 25) return Colors.teal.shade500;
    if (celsius < 30) return Colors.orange.shade600;
    if (celsius < 35) return Colors.deepOrange.shade600;
    return Colors.red.shade600;
  }

  static Color getHumidityColor(int? humidity) {
    if (humidity == null) return SColors.primary;
    if (humidity < 30) return Colors.brown.shade400; // Dry
    if (humidity < 60) return Colors.green.shade500; // Comfortable
    if (humidity < 80) return Colors.blue.shade500; // Humid
    return Colors.indigo.shade600; // Very Humid
  }

  static Color? getSunEventColor(int? timestamp, Color baseColor) {
    if (timestamp == null) return null;

    final now = DateTime.now();
    final eventTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final diffInSeconds = now.difference(eventTime).inSeconds.abs();

    const windowInSeconds = 90 * 60;

    if (diffInSeconds <= windowInSeconds) {
      // Calculate proximity (0.0 at exact time, 1.0 at 90 min away)
      final proximity = diffInSeconds / windowInSeconds;
      // Opacity: 1.0 at exact time, 0.60 at 90 min boundaries
      final opacity = 1.0 - (proximity * 0.40);
      return baseColor.withAlpha((opacity * 255).toInt());
    }

    return null;
  }
}
