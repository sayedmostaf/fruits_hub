import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fruits_hub/features/settings/presentation/views/widgets/custom_setting_item.dart';

class CustomSwitchButton extends StatelessWidget {
  const CustomSwitchButton({
    super.key,
    required this.title,
    required this.svgIcon,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.inActiveColor,
  });
  final String title, svgIcon;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor, inActiveColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomSettingItem(
      onTap: () => onChanged(!value),
      trailing: FlutterSwitch(
        width: 29,
        height: 17,
        toggleSize: 13,
        borderRadius: 30,
        padding: 2,
        value: value,
        onToggle: onChanged,
        activeColor: activeColor ?? theme.colorScheme.primary,
        inactiveColor:
            inActiveColor ?? theme.colorScheme.secondary.withOpacity(0.5),
      ),
      title: title,
      image: svgIcon,
    );
  }
}
