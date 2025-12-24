import 'package:flutter/material.dart';
import 'package:hudle_task_app/coman/widgets/settings_menu_tile.dart';
import 'package:hudle_task_app/domain/models/location_model.dart';
import 'package:hudle_task_app/utils/constants/sizes.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class LocationMenuTile extends StatelessWidget {
  final LocationModel location;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onRemove;
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
