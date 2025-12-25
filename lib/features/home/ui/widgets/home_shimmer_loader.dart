import 'package:flutter/material.dart';
import 'package:hudle_task_app/common/shimmer/shimmer.dart';
import 'package:hudle_task_app/utils/constants/sizes.dart';

class HomeShimmerLoader extends StatelessWidget {
  const HomeShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header Shimmer
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.spaceFromEdge,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BShimmerEffect(width: 100, height: 100),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    BShimmerEffect(width: 80, height: 20),
                    SizedBox(height: 8),
                    BShimmerEffect(width: 60, height: 15),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: Sizes.spaceBtwSections),

          // Main Graphic Shimmer
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.spaceFromEdge,
            ),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Sizes.borderRadiusXl),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Centered circular shape for the weather icon
                  const BShimmerEffect(
                    width: 150,
                    height: 150,
                    borderRadius: 500,
                  ),
                  const SizedBox(height: 20),
                  // Grid Shimmer
                  GridView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(Sizes.md),
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          childAspectRatio: 1.2,
                        ),
                    itemCount: 6,
                    itemBuilder: (_, _) => const BShimmerEffect(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
