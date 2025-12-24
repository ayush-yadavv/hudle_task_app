import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hudle_task_app/utils/constants/colors.dart';
import 'package:hudle_task_app/utils/helpers/helper_functions.dart';

class SFullScreenLoader {
  static void openLoadingDialog(
    BuildContext context,
    String text,
    String animation,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Stack(
          children: [
            // Blurred background
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                color: SHelperFunctions.isDarkMode(context)
                    ? SColors.dark.withAlpha((255 * 0.75).toInt())
                    : SColors.white.withAlpha((255 * 0.75).toInt()),
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            // Foreground content
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  Text(
                    text,
                    style: TextStyle(
                      color: SHelperFunctions.isDarkMode(context)
                          ? SColors.white
                          : SColors.black,
                      fontSize: 20,
                    ),
                  ),
                  // SAnimationLoaderWidget(text: text, animation: animation),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void stopLoading(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void showAlert(
    BuildContext context,
    String title,
    String message,
    List<Widget>? actions,
  ) {
    showAdaptiveDialog(
      barrierColor: Colors.black38,
      // traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          elevation: 2,
          actions:
              actions ??
              [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
        );
      },
    );
  }
}
