import 'package:flutter/material.dart';
import 'package:hudle_task_app/utils/constants/sizes.dart';

/// A reusable widget for displaying an empty state in search views.
class SearchEmptyState extends StatelessWidget {
  const SearchEmptyState({
    super.key,
    required this.message,
    required this.icon,
  });

  /// The message to display in the empty state.
  final String message;

  /// The icon to display above the message.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: Sizes.iconLg),
          const SizedBox(height: Sizes.spaceBtwInputFields),
          Text(message),
        ],
      ),
    );
  }
}
