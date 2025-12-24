import 'package:flutter/material.dart';
import 'package:hudle_task_app/coman/shimmer/shimmer.dart';
import 'package:hudle_task_app/utils/constants/sizes.dart';

class HomeShimmerLoader extends StatelessWidget {
  const HomeShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header Shimmer
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BShimmerEffect(
                width: 150,
                height: 100,
                borderRadius: Sizes.borderRadiusMd,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  BShimmerEffect(
                    width: 80,
                    height: 20,
                    borderRadius: Sizes.borderRadiusSm,
                  ),
                  SizedBox(height: 8),
                  BShimmerEffect(
                    width: 60,
                    height: 15,
                    borderRadius: Sizes.borderRadiusSm,
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: Sizes.spaceBtwSections),

        // Main Graphic Shimmer
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.defaultSpace),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Sizes.borderRadiusXl),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Centered circular shape for the weather icon
                  const BShimmerEffect(
                    width: 150,
                    height: 150,
                    borderRadius: 75, // Circle
                  ),
                  const SizedBox(height: 40),
                  // Grid Shimmer
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(Sizes.md),
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: Sizes.md,
                            crossAxisSpacing: Sizes.md,
                            childAspectRatio: 1.2,
                          ),
                      itemCount: 6,
                      itemBuilder: (_, _) => const BShimmerEffect(
                        borderRadius: Sizes.borderRadiusLg,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
