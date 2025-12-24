import 'package:flutter/material.dart';

class StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minHeight;
  final double maxHeight;

  StickyHeaderDelegate({
    required this.child,
    required this.minHeight,
    required this.maxHeight,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final currentHeight = maxHeight - shrinkOffset;
    final denominator = (maxHeight * 0.75) - minHeight;
    final double opacity = denominator <= 0
        ? 1.0
        : ((currentHeight - minHeight) / denominator).clamp(0.0, 1.0);

    return SizedBox(
      height: currentHeight.clamp(minHeight, maxHeight),
      width: double.infinity,
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Opacity(opacity: opacity, child: child),
      ),
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(StickyHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
