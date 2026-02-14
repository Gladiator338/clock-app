import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';

enum AppThemeMode { system, light, dark }

/// Palette: primary (solid for buttons), background (light), surface, onSurface (solid/dark text).
class _CustomPalette {
  final Color primary;
  final Color onPrimary;
  final Color background;
  final Color surface;
  final Color onSurface;
  final Color secondary;
  final Color onSecondary;
  final Color divider;
  final Color idle;

  const _CustomPalette({
    required this.primary,
    required this.onPrimary,
    required this.background,
    required this.surface,
    required this.onSurface,
    required this.secondary,
    required this.onSecondary,
    required this.divider,
    required this.idle,
  });
}

class AppTheme {
  AppTheme._();

  static _CustomPalette? _lightPalette(String colorKey) {
    switch (colorKey) {
      case 'blue':
        return const _CustomPalette(
          primary: Color(0xFF1565C0),
          onPrimary: Colors.white,
          background: Color(0xFFE3F2FD),
          surface: Color(0xFFBBDEFB),
          onSurface: Color(0xFF0D47A1),
          secondary: Color(0xFF0D47A1),
          onSecondary: Color(0xFF0D47A1),
          divider: Color(0xFF90CAF9),
          idle: Color(0xFF64B5F6),
        );
      case 'green':
        return const _CustomPalette(
          primary: Color(0xFF2E7D32),
          onPrimary: Colors.white,
          background: Color(0xFFE8F5E9),
          surface: Color(0xFFC8E6C9),
          onSurface: Color(0xFF1B5E20),
          secondary: Color(0xFF1B5E20),
          onSecondary: Color(0xFF1B5E20),
          divider: Color(0xFFA5D6A7),
          idle: Color(0xFF66BB6A),
        );
      case 'red':
        return const _CustomPalette(
          primary: Color(0xFFC62828),
          onPrimary: Colors.white,
          background: Color(0xFFFFEBEE),
          surface: Color(0xFFFFCDD2),
          onSurface: Color(0xFFB71C1C),
          secondary: Color(0xFFB71C1C),
          onSecondary: Color(0xFFB71C1C),
          divider: Color(0xFFEF9A9A),
          idle: Color(0xFFE57373),
        );
      case 'grey':
        return const _CustomPalette(
          primary: Color(0xFF455A64),
          onPrimary: Colors.white,
          background: Color(0xFFECEFF1),
          surface: Color(0xFFCFD8DC),
          onSurface: Color(0xFF263238),
          secondary: Color(0xFF263238),
          onSecondary: Color(0xFF263238),
          divider: Color(0xFFB0BEC5),
          idle: Color(0xFF78909C),
        );
      default:
        return null;
    }
  }

  static _CustomPalette? _darkPalette(String colorKey) {
    switch (colorKey) {
      case 'blue':
        return const _CustomPalette(
          primary: Color(0xFF42A5F5),
          onPrimary: Colors.white,
          background: Color(0xFF0D47A1),
          surface: Color(0xFF1565C0),
          onSurface: Color(0xFFBBDEFB),
          secondary: Color(0xFF90CAF9),
          onSecondary: Color(0xFF0D47A1),
          divider: Color(0xFF1565C0),
          idle: Color(0xFF64B5F6),
        );
      case 'green':
        return const _CustomPalette(
          primary: Color(0xFF66BB6A),
          onPrimary: Colors.white,
          background: Color(0xFF1B5E20),
          surface: Color(0xFF2E7D32),
          onSurface: Color(0xFFC8E6C9),
          secondary: Color(0xFFA5D6A7),
          onSecondary: Color(0xFF1B5E20),
          divider: Color(0xFF2E7D32),
          idle: Color(0xFF81C784),
        );
      case 'red':
        return const _CustomPalette(
          primary: Color(0xFFE57373),
          onPrimary: Colors.white,
          background: Color(0xFFB71C1C),
          surface: Color(0xFFC62828),
          onSurface: Color(0xFFFFCDD2),
          secondary: Color(0xFFEF9A9A),
          onSecondary: Color(0xFFB71C1C),
          divider: Color(0xFFC62828),
          idle: Color(0xFFEF5350),
        );
      case 'grey':
        return const _CustomPalette(
          primary: Color(0xFF78909C),
          onPrimary: Colors.white,
          background: Color(0xFF263238),
          surface: Color(0xFF455A64),
          onSurface: Color(0xFFCFD8DC),
          secondary: Color(0xFFB0BEC5),
          onSecondary: Color(0xFF263238),
          divider: Color(0xFF455A64),
          idle: Color(0xFF90A4AE),
        );
      default:
        return null;
    }
  }

  static ThemeData light([String colorKey = 'default']) {
    final custom = _lightPalette(colorKey);
    if (custom == null) {
      return ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightBackground,
        colorScheme: const ColorScheme.light(
          primary: AppColors.lightAccent,
          onPrimary: Colors.white,
          surface: AppColors.lightSurface,
          onSurface: AppColors.lightPrimary,
          secondary: AppColors.lightSecondary,
          onSecondary: AppColors.lightPrimary,
          outline: AppColors.lightDivider,
        ),
        textTheme: AppTypography.textTheme(false),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.lightBackground,
          foregroundColor: AppColors.lightPrimary,
          elevation: 0,
          scrolledUnderElevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.lightSurface,
          selectedItemColor: AppColors.lightAccent,
          unselectedItemColor: AppColors.lightIdle,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        dividerColor: AppColors.lightDivider,
        splashFactory: InkRipple.splashFactory,
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(foregroundColor: Colors.white),
        ),
      );
    }
    final textTheme = AppTypography.textTheme(false).apply(bodyColor: custom.onSurface, displayColor: custom.onSurface);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: custom.background,
      colorScheme: ColorScheme.light(
        primary: custom.primary,
        onPrimary: custom.onPrimary,
        surface: custom.surface,
        onSurface: custom.onSurface,
        secondary: custom.secondary,
        onSecondary: custom.onSecondary,
        outline: custom.divider,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: custom.background,
        foregroundColor: custom.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: custom.surface,
        selectedItemColor: custom.primary,
        unselectedItemColor: custom.idle,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      dividerColor: custom.divider,
      splashFactory: InkRipple.splashFactory,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: custom.primary,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  static ThemeData dark([String colorKey = 'default']) {
    final custom = _darkPalette(colorKey);
    if (custom == null) {
      return ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBackground,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.darkAccent,
          onPrimary: Colors.black87,
          surface: AppColors.darkSurface,
          onSurface: AppColors.darkPrimary,
          secondary: AppColors.darkSecondary,
          onSecondary: AppColors.darkPrimary,
          outline: AppColors.darkDivider,
        ),
        textTheme: AppTypography.textTheme(true),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkBackground,
          foregroundColor: AppColors.darkPrimary,
          elevation: 0,
          scrolledUnderElevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.darkSurface,
          selectedItemColor: AppColors.darkAccent,
          unselectedItemColor: AppColors.darkIdle,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        dividerColor: AppColors.darkDivider,
        splashFactory: InkRipple.splashFactory,
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(foregroundColor: Colors.white),
        ),
      );
    }
    final textTheme = AppTypography.textTheme(true).apply(bodyColor: custom.onSurface, displayColor: custom.onSurface);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: custom.background,
      colorScheme: ColorScheme.dark(
        primary: custom.primary,
        onPrimary: custom.onPrimary,
        surface: custom.surface,
        onSurface: custom.onSurface,
        secondary: custom.secondary,
        onSecondary: custom.onSecondary,
        outline: custom.divider,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: custom.background,
        foregroundColor: custom.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: custom.surface,
        selectedItemColor: custom.primary,
        unselectedItemColor: custom.idle,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      dividerColor: custom.divider,
      splashFactory: InkRipple.splashFactory,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: custom.primary,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
