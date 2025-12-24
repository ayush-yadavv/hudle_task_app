import 'package:flutter/material.dart';
import 'package:hudle_task_app/coman/widgets/section_heading.dart';
import 'package:hudle_task_app/utils/constants/sizes.dart';

class ListSection extends StatelessWidget {
  final String? sectionHeading;
  final String? sectionDescription;

  /// Use either [children] for static list OR [itemCount] + [itemBuilder] for lazy building
  final List<Widget>? children;

  /// Number of items for lazy building (use with [itemBuilder])
  final int? itemCount;

  /// Builder function for lazy building (use with [itemCount])
  final Widget Function(BuildContext context, int index)? itemBuilder;

  const ListSection({
    super.key,
    this.sectionHeading,
    this.sectionDescription,
    this.children,
    this.itemCount,
    this.itemBuilder,
  }) : assert(
         children != null || (itemCount != null && itemBuilder != null),
         'Either provide children OR (itemCount + itemBuilder)',
       );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        horizontal: Sizes.spaceFromEdge,
        vertical: Sizes.spaceFromEdge / 2,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (sectionHeading != null)
            BSectionHeading(
              title: sectionHeading!,
              padding: EdgeInsetsGeometry.only(left: 0),
            ),
          if (sectionDescription != null)
            SizedBox(height: Sizes.spaceFromEdge / 2),
          if (sectionDescription != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(sectionDescription!),
            ),

          if (sectionHeading != null || sectionDescription != null)
            SizedBox(height: Sizes.spaceFromEdge),

          ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadiusGeometry.circular(Sizes.cardRadiusXxl),
            child: children != null
                ? Column(children: children!)
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: itemCount!,
                    itemBuilder: itemBuilder!,
                  ),
          ),
        ],
      ),
    );
  }
}
