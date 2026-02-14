import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';

const _keyThemeMode = 'clock_app_theme_mode';
const _keyThemeColor = 'clock_app_theme_color';

class ThemePreference {
  ThemePreference._();
  static final instance = ThemePreference._();

  Future<AppThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_keyThemeMode);
    switch (value) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      default:
        return AppThemeMode.system;
    }
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    final value = mode == AppThemeMode.light
        ? 'light'
        : mode == AppThemeMode.dark
            ? 'dark'
            : 'system';
    await prefs.setString(_keyThemeMode, value);
  }

  ThemeMode toThemeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  /// Theme color key: 'default' | 'blue' | 'green' | 'red' | 'grey'
  Future<String> getThemeColor() async {
    final prefs = await SharedPreferences.getInstance();
    final v = prefs.getString(_keyThemeColor);
    if (v == null) return 'default';
    if (['default', 'blue', 'green', 'red', 'grey'].contains(v)) return v;
    return 'default';
  }

  Future<void> setThemeColor(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeColor, value);
  }
}
