import 'package:flutter/material.dart';
import 'package:clock_app/features/clock/clock_screen.dart';
import 'package:clock_app/features/timer/timer_screen.dart';
import 'package:clock_app/features/alarm/alarm_screen.dart';
import 'package:clock_app/features/stopwatch/stopwatch_screen.dart';
import 'package:clock_app/features/settings/settings_screen.dart';
import 'package:clock_app/shared/theme/app_theme.dart';
import 'package:clock_app/shared/theme/theme_preference.dart';

class ClockApp extends StatefulWidget {
  const ClockApp({super.key});

  @override
  State<ClockApp> createState() => _ClockAppState();
}

class _ClockAppState extends State<ClockApp> {
  int _currentIndex = 0;
  AppThemeMode _themeMode = AppThemeMode.system;
  String _themeColor = 'default';
  int _settingsReturnKey = 0;
  final _themePref = ThemePreference.instance;
  final _navigatorKey = GlobalKey<NavigatorState>();

  static const _tabs = [
    (label: 'Clock', icon: Icons.schedule),
    (label: 'Timer', icon: Icons.timer_outlined),
    (label: 'Alarm', icon: Icons.alarm_outlined),
    (label: 'Stopwatch', icon: Icons.timer),
  ];

  @override
  void initState() {
    super.initState();
    _themePref.getThemeMode().then((mode) {
      if (mounted) setState(() => _themeMode = mode);
    });
    _themePref.getThemeColor().then((color) {
      if (mounted) setState(() => _themeColor = color);
    });
  }

  void _openSettings() async {
    final navigator = _navigatorKey.currentState;
    if (navigator == null) return;
    try {
      final result = await navigator.push<AppThemeMode>(
        PageRouteBuilder<AppThemeMode>(
          pageBuilder: (_, __, ___) => SettingsScreen(
            onThemeChanged: (mode) {
              if (mode != null && mounted) setState(() => _themeMode = mode);
            },
            onThemeColorChanged: (color) {
              if (color != null && mounted) setState(() => _themeColor = color);
            },
          ),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.02),
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 250),
        ),
      );
      if (mounted) {
        setState(() {
          if (result != null) _themeMode = result;
          _settingsReturnKey++;
        });
      }
    } catch (e, st) {
      debugPrint('Settings navigation error: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open settings')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Clock',
      theme: AppTheme.light(_themeColor),
      darkTheme: AppTheme.dark(_themeColor),
      themeMode: _themePref.toThemeMode(_themeMode),
      home: Scaffold(
        appBar: AppBar(
          title: Text(_tabs[_currentIndex].label),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: _openSettings,
            ),
          ],
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            ClockScreen(key: ValueKey(_settingsReturnKey)),
            const TimerScreen(),
            AlarmScreen(key: ValueKey(_settingsReturnKey)),
            const StopwatchScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            for (final t in _tabs)
              BottomNavigationBarItem(
                icon: Icon(t.icon),
                label: t.label,
              ),
          ],
        ),
      ),
    );
  }
}
