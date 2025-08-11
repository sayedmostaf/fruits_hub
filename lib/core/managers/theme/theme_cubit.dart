import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/services/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode?> {
  static const _themeKey = 'isDark';
  ThemeCubit() : super(ThemeMode.light) {
    _loadSavedTheme();
  }
  void toggleTheme() {
    final isDark = state == ThemeMode.dark;
    final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
    emit(newMode);

    Pref.setBool(_themeKey, !isDark);
  }

  void _loadSavedTheme() {
    final isDark = Pref.getBool(_themeKey);
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
