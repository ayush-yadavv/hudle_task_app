import 'package:flutter/material.dart';
import 'package:hudle_task_app/common/widgets/list_section.dart';
import 'package:hudle_task_app/common/widgets/settings_menu_tile.dart';

class SettingsRadioOption<T> {
  final String label;
  final T value;

  const SettingsRadioOption({required this.label, required this.value});
}

class SettingsRadioSection<T> extends StatelessWidget {
  final String title;
  final T groupValue;
  final List<SettingsRadioOption<T>> options;
  final ValueChanged<T> onChanged;

  const SettingsRadioSection({
    super.key,
    required this.title,
    required this.groupValue,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioGroup<T>(
      groupValue: groupValue,
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
      child: ListSection(
        sectionHeading: title,
        children: options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final isLast = index == options.length - 1;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SettingMenuTile(
                title: option.label,
                trailing: Radio<T>.adaptive(value: option.value),
                onTap: () => onChanged(option.value),
              ),
              if (!isLast) const SizedBox(height: 2),
            ],
          );
        }).toList(),
      ),
    );
  }
}
