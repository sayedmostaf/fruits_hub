import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/managers/theme/theme_cubit.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/features/settings/presentation/views/widgets/custom_switch_button.dart';

class ThemeSwitchSettingItem extends StatelessWidget {
  const ThemeSwitchSettingItem({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final isDark = themeCubit.state == ThemeMode.dark;

    return CustomSwitchButton(
      title: title,
      svgIcon: Assets.imagesMagicpen,
      subtitle: isDark ? AppStrings.darkModeEnabled.tr() : AppStrings.lightModeEnabled.tr(),
      value: isDark,
      onChanged: (_) => themeCubit.toggleTheme(),
      // Enhanced styling for theme switch
      switchSize: SwitchSize.medium,
      hapticFeedback: true,
      animationDuration: const Duration(milliseconds: 250),
      // Theme-appropriate colors
      activeColor:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.amber.shade400
              : Colors.indigo.shade600,
      inactiveColor:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade600
              : Colors.grey.shade400,
      // Optional: Add theme-specific labels
      showLabels: false, // Set to true if you want ON/OFF labels
      activeText: AppStrings.dark.tr(),
      inactiveText: AppStrings.light.tr(),
    );
  }
}
