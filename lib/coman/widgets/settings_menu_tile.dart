import 'package:flutter/material.dart';
import 'package:hudle_task_app/utils/constants/colors.dart';
import 'package:hudle_task_app/utils/constants/sizes.dart';
import 'package:hudle_task_app/utils/helpers/helper_functions.dart';

class SettingMenuTile extends StatelessWidget {
  const SettingMenuTile({
    super.key,
    required this.title,
    this.icon,
    this.onTap,
    this.subTitle,
    this.trailing,
  });

  final IconData? icon;
  final String title;

  /// Can be [Text], [RichText], or any widget (or null).
  final Widget? subTitle;

  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);
    return Material(
      color: dark ? SColors.darkContainer : SColors.white,
      borderRadius: BorderRadius.circular(Sizes.borderRadiusSm),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          minVerticalPadding: 12,
          subtitleTextStyle: Theme.of(context).textTheme.bodyMedium,

          contentPadding: EdgeInsets.all(0),
          leading: icon != null
              ? Padding(
                  padding: const EdgeInsets.only(
                    left: Sizes.defaultSpace,
                    right: Sizes.sm,
                  ),
                  child: Icon(icon, size: Sizes.iconMd),
                )
              : SizedBox(width: Sizes.spaceFromEdge),

          title: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: subTitle,
          trailing: Padding(
            padding: const EdgeInsets.only(
              right: Sizes.defaultSpace,
            ), // Add right padding to trailing widget
            child: trailing,
          ),
          tileColor: Colors.transparent,
        ),
      ),
    );
  }
}
