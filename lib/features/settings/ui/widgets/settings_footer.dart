import 'package:flutter/material.dart';
import 'package:hudle_task_app/utils/constants/app_configs.dart';
import 'package:hudle_task_app/utils/constants/sizes.dart';

class SettingsFooter extends StatelessWidget {
  const SettingsFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppConfigs.applicationName,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(height: Sizes.spaceBtwItems),
        Text('App Version: ${AppConfigs.apkVersion}'),
      ],
    );
  }
}
