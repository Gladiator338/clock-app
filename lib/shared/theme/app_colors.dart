import 'package:flutter/material.dart';

/// Semantic colors for light and dark themes.
/// Restrained palette: one accent, neutrals, clear semantic states.
class AppColors {
  AppColors._();

  // Light theme
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightPrimary = Color(0xFF1A1A1A);
  static const Color lightSecondary = Color(0xFF6B6B6B);
  static const Color lightAccent = Color(0xFF2563EB);
  static const Color lightAccentMuted = Color(0xFF93C5FD);
  static const Color lightDivider = Color(0xFFE5E5E5);
  static const Color lightIdle = Color(0xFFB4B4B4);
  static const Color lightActive = Color(0xFF2563EB);

  // Dark theme
  static const Color darkBackground = Color(0xFF0D0D0D);
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color darkPrimary = Color(0xFFF5F5F5);
  static const Color darkSecondary = Color(0xFFA3A3A3);
  static const Color darkAccent = Color(0xFF60A5FA);
  static const Color darkAccentMuted = Color(0xFF1E3A5F);
  static const Color darkDivider = Color(0xFF2A2A2A);
  static const Color darkIdle = Color(0xFF525252);
  static const Color darkActive = Color(0xFF60A5FA);
}
