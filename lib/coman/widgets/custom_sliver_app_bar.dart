import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hudle_task_app/utils/constants/colors.dart';
import 'package:hudle_task_app/utils/constants/sizes.dart';

class ASliverAppBar extends StatelessWidget {
  const ASliverAppBar({
    super.key,
    this.expandedHeight,
    required this.title,
    this.implyLeading = false,
  });

  final String title;
  final double? expandedHeight;
  final bool implyLeading;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = dark ? SColors.darkContainer : SColors.white;

    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: implyLeading,
      expandedHeight: expandedHeight ?? 130,
      backgroundColor: Colors.transparent,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final settings = context
              .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
          final deltaExtent = settings!.maxExtent - settings.minExtent;
          final t =
              (1.0 -
                      (settings.currentExtent - settings.minExtent) /
                          deltaExtent)
                  .clamp(0.0, 1.0);

          return _GlassmorphicAppBar(
            opacity: t,
            backgroundColor: backgroundColor,
            child: FlexibleSpaceBar(
              background: const SizedBox.shrink(),
              expandedTitleScale: 1.8,
              collapseMode: CollapseMode.parallax,
              stretchModes: const [StretchMode.fadeTitle],
              titlePadding: EdgeInsetsDirectional.only(
                start: implyLeading ? 24 + (40 * t) : Sizes.defaultSpace,
                bottom: 16,
              ),
              title: Text(
                title,
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GlassmorphicAppBar extends StatelessWidget {
  const _GlassmorphicAppBar({
    required this.opacity,
    required this.backgroundColor,
    required this.child,
  });

  final double opacity;
  final Color backgroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Glassmorphism background - only build when needed
        if (opacity > 0.01)
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10 * opacity,
                sigmaY: 10 * opacity,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: backgroundColor.withValues(alpha: 0.7 * opacity),
                ),
              ),
            ),
          ),
        // FlexibleSpaceBar content
        child,
      ],
    );
  }
}
