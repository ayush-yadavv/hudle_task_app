import 'package:flutter/material.dart';
import 'package:hudle_task_app/utils/constants/colors.dart';
import 'package:hudle_task_app/utils/constants/sizes.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class SLoader {
  static void hideSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  static void errorSnackBar(
    BuildContext context, {
    String title = 'Oops!',
    String message = '',
    int duration = 2,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Iconsax.warning_2, color: SColors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(message),
                ],
              ),
            ),
          ],
        ),
        duration: Duration(seconds: duration),
        backgroundColor: SColors.error,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  static void successSnackBar(
    BuildContext context, {
    String title = 'Yay!',
    String message = '',
    int duration = 2,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Iconsax.check, color: SColors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(message),
                ],
              ),
            ),
          ],
        ),
        duration: Duration(seconds: duration),
        backgroundColor: SColors.success,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  static void warningSnackBar(
    BuildContext context, {
    String title = 'warning',
    String message = '',
    int duration = 2,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: duration),
        backgroundColor: SColors.warning,
      ),
    );
  }

  // static void customToast(String message) {
  //   ScaffoldMessenger.of(Get.context!).showSnackBar(
  //     SnackBar(
  //       elevation: 0,
  //       duration: const Duration(seconds: 2),
  //       backgroundColor: SColors.transparent,
  //       content: Container(
  //         padding: const EdgeInsets.all(12),
  //         margin: const EdgeInsets.symmetric(horizontal: 30),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(30),
  //           color: SHelperFunctions.isDarkMode(Get.context!)
  //               ? SColors.darkerGrey.withOpacity(0.9)
  //               : SColors.grey.withOpacity(0.9),
  //         ),
  //         child: Center(
  //           child: Text(
  //             message,
  //             style: Theme.of(Get.context!).textTheme.labelLarge,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  static void loading(BuildContext context, {String? loadingText}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(SColors.primary),
              ),
              if (loadingText != null && loadingText.isNotEmpty)
                const SizedBox(height: Sizes.spaceBtwItems),
              if (loadingText != null && loadingText.isNotEmpty)
                Text(
                  loadingText,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
            ],
          ),
        ),
      ),
    );
  }

  static void stopLoading(BuildContext context) {
    Navigator.of(context).pop();
  }
}
