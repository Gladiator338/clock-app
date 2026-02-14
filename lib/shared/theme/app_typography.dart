import 'package:flutter/material.dart';

/// Expressive typography: strong display for time/numbers, clear hierarchy.
class AppTypography {
  AppTypography._();

  static TextTheme textTheme(bool isDark) {
    final color = isDark ? const Color(0xFFF5F5F5) : const Color(0xFF1A1A1A);
    final secondary = isDark ? const Color(0xFFA3A3A3) : const Color(0xFF6B6B6B);
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.w200,
        letterSpacing: -2,
        color: color,
        height: 1.0,
      ),
      displayMedium: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w300,
        letterSpacing: -1,
        color: color,
        height: 1.1,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.5,
        color: color,
        height: 1.2,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.3,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.4,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.4,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondary,
        height: 1.5,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.4,
      ),
    );
  }
}
