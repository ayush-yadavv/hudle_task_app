import 'package:flutter/material.dart';
import 'package:hudle_task_app/utils/constants/sizes.dart';

class BSectionHeading extends StatelessWidget {
  const BSectionHeading({
    super.key,

    required this.title,
    this.action,
    this.padding,
    this.icon,
    this.textStyle,
  });

  final String title;
  final EdgeInsetsGeometry? padding;
  final List<Widget>? action;
  final IconData? icon;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: Sizes.defaultSpace),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) Icon(icon, grade: 24),
              if (icon != null) const SizedBox(width: 12),
              Text(
                title,
                style: textStyle ?? Theme.of(context).textTheme.headlineSmall!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          if (action != null) Row(children: action!),
        ],
      ),
    );
  }
}
