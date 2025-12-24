import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hudle_task_app/utils/constants/colors.dart';
import 'package:hudle_task_app/utils/helpers/helper_functions.dart';

class SToast {
  static void showToast(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    Color? textColor,
    ToastGravity position = ToastGravity.CENTER,
  }) {
    Fluttertoast.showToast(
      msg: message,
      webShowClose: true,
      toastLength: Toast.LENGTH_SHORT,
      gravity: position,
      timeInSecForIosWeb: 1,
      backgroundColor:
          backgroundColor ??
          (SHelperFunctions.isDarkMode(context)
                  ? SColors.darkGrey
                  : SColors.grey)
              .withAlpha(180),
      textColor: textColor,
      fontSize: 12.0,
    );
  }
}
