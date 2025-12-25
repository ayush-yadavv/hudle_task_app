import 'package:flutter/material.dart';
import 'package:hudle_task_app/common/widgets/settings_menu_tile.dart';
import 'package:hudle_task_app/domain/models/location_data_model/location_model.dart';
import 'package:hudle_task_app/utils/constants/sizes.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

/// A menu tile representing a location, used in search results and history lists.
///
/// It displays the location name and allows for selection or removal from history.
class LocationMenuTile extends StatelessWidget {
  /// The location data model to display.
  final LocationModel location;

  /// Whether this location is currently selected in the app.
  final bool isSelected;

  /// Callback triggered when the tile is tapped.
  final VoidCallback onTap;

  /// Optional callback triggered when the remove icon is tapped (if [showRemoveIcon] is true).
  final VoidCallback? onRemove;

  /// Whether to show a removal icon/tick based on [isSelected].
  final bool showRemoveIcon;

  const LocationMenuTile({
    super.key,
    required this.location,
    required this.onTap,
    this.isSelected = false,
    this.onRemove,
    this.showRemoveIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return SettingMenuTile(
      isSelected: isSelected,
      title: location.name ?? 'Unknown',
      subTitle: Text(
        location.displayName,
        style: TextStyle(color: isSelected ? Colors.white : null),
      ),
      trailing: showRemoveIcon
          ? (isSelected
                ? IgnorePointer(
                    child: IconButton(
                      icon: const Icon(
                        Iconsax.tick_circle_copy,
                        color: Colors.white,
                        size: Sizes.iconMd,
                      ),
                      onPressed: () {},
                    ),
                  )
                : IconButton(
                    icon: const Icon(
                      Iconsax.close_circle_copy,
                      size: Sizes.iconMd,
                    ),
                    onPressed: onRemove,
                  ))
          : const Icon(Iconsax.arrow_right_2_copy),
      onTap: onTap,
    );
  }
}
