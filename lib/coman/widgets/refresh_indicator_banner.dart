import 'package:flutter/material.dart';
import 'package:hudle_task_app/utils/constants/colors.dart';

/// A beautiful inline refresh indicator banner that shows at the top
/// while data is being refreshed, keeping the content visible
class RefreshIndicatorBanner extends StatefulWidget {
  const RefreshIndicatorBanner({super.key, this.message = 'Refreshing...'});

  final String message;

  @override
  State<RefreshIndicatorBanner> createState() => _RefreshIndicatorBannerState();
}

class _RefreshIndicatorBannerState extends State<RefreshIndicatorBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = SColors.primary;
    final secondaryColor = SColors.secondary;

    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      primaryColor.withValues(alpha: 0.3),
                      secondaryColor.withValues(alpha: 0.2),
                      primaryColor.withValues(alpha: 0.3),
                    ]
                  : [
                      primaryColor.withValues(alpha: 0.1),
                      secondaryColor.withValues(alpha: 0.15),
                      primaryColor.withValues(alpha: 0.1),
                    ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0.0, _shimmerController.value, 1.0],
            ),
            border: Border(
              bottom: BorderSide(
                color: primaryColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
          ),
          child: child,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(SColors.primary),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            widget.message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: SColors.primary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
