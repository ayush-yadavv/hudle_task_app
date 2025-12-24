import 'package:flutter/material.dart';
import 'package:hudle_task_app/coman/widgets/section_heading.dart';
import 'package:hudle_task_app/utils/constants/sizes.dart';

class ListSection extends StatelessWidget {
  final String? sectionHeading;
  final String? sectionDescription;
  final List<Widget> children;

  const ListSection({
    super.key,
    this.sectionHeading,
    this.sectionDescription,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        horizontal: Sizes.spaceFromEdge,
        vertical: Sizes.spaceFromEdge / 2,
      ),
      child: Column(
        children: [
          // const SizedBox(height: Sizes.spaceBtwItems),
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
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}
