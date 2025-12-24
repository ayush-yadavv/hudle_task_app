import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hudle_task_app/utils/constants/app_configs.dart';
import 'package:hudle_task_app/utils/constants/images_str.dart';
import 'package:hudle_task_app/utils/constants/sizes.dart';

class SettingsFooter extends StatelessWidget {
  const SettingsFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(thickness: 4, height: 4),
        const SizedBox(height: Sizes.spaceBtwItems),
        SvgPicture.asset(
          SImages.appLogoSvg,
          height: 50,
          width: 50,
          colorFilter: ColorFilter.mode(
            Theme.of(context).iconTheme.color!,
            BlendMode.srcIn,
          ),
        ),
        Text(
          AppConfigs.applicationName,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: Sizes.spaceBtwItems),
        Text(
          AppConfigs.appDescription,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: Sizes.spaceBtwItems),
        Text(
          'App Version: ${AppConfigs.apkVersion}',
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }
}
