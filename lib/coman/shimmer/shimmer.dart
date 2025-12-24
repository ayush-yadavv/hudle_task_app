import 'package:flutter/material.dart';
import 'package:hudle_task_app/utils/constants/colors.dart';
import 'package:hudle_task_app/utils/helpers/helper_functions.dart';
import 'package:shimmer/shimmer.dart';

class BShimmerEffect extends StatelessWidget {
  const BShimmerEffect({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 15,
    this.color,
  });

  final double? width, height;
  final double borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);
    return Shimmer.fromColors(
      direction: ShimmerDirection.ltr,
      // baseColor: dark ? Colors.grey[850]! : Colors.grey[300]!,
      baseColor: dark ? SColors.darkContainer : SColors.lightContainer,
      highlightColor: (dark ? Colors.grey[700]! : Colors.grey[100]!),
      child: Container(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        decoration: BoxDecoration(
          color: color ?? (dark ? SColors.darkerGrey : SColors.white),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
