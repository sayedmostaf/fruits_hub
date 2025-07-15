import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_colors.dart';

class AppTheme {
  static get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Cairo',
      scaffoldBackgroundColor: AppColor.background,
      primaryColor: AppColor.primaryGreen,
      iconTheme: IconThemeData(color: AppColor.iconColor),
      colorScheme: ColorScheme.light(
        primary: AppColor.primaryGreen,
        secondary: AppColor.textWarning,
        surface: AppColor.cardBackground,
        background: AppColor.background,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: AppColor.textPrimary, fontFamily: 'Cairo'),
        bodyMedium: TextStyle(
          color: AppColor.textSecondary,
          fontFamily: 'Cairo',
        ),
        titleLarge: TextStyle(color: AppColor.textSuccess, fontFamily: 'Cairo'),
        titleMedium: TextStyle(
          color: AppColor.textWarning,
          fontFamily: 'Cairo',
        ),
        labelLarge: TextStyle(
          color: AppColor.textHighlight,
          fontFamily: 'Cairo',
        ),
        labelMedium: TextStyle(
          color: AppColor.textDisabled,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Cairo',
      scaffoldBackgroundColor: AppColor.darkBackground,
      primaryColor: AppColor.primaryGreen,
      iconTheme: const IconThemeData(color: AppColor.darkIconColor),
      colorScheme: const ColorScheme.dark(
        primary: AppColor.primaryGreen,
        secondary: AppColor.textWarningDark,
        surface: AppColor.darkCardBackground,
        background: AppColor.darkBackground,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: AppColor.darkTextPrimary,
          fontFamily: 'Cairo',
        ),
        bodyMedium: TextStyle(
          color: AppColor.darkTextSecondary,
          fontFamily: 'Cairo',
        ),
        titleLarge: TextStyle(color: AppColor.textSuccess, fontFamily: 'Cairo'),
        titleMedium: TextStyle(
          color: AppColor.textWarningDark,
          fontFamily: 'Cairo',
        ),
        labelLarge: TextStyle(
          color: AppColor.textHighlight,
          fontFamily: 'Cairo',
        ),
        labelMedium: TextStyle(
          color: AppColor.darkTextDisabled,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }
}
