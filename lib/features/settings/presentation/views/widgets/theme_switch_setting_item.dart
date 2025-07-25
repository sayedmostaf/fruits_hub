import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/managers/theme/theme_cubit.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
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
      value: isDark,
      onChanged: (_) => themeCubit.toggleTheme(),
    );
  }
}
