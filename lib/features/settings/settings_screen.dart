import 'package:flutter/material.dart';
import 'package:clock_app/shared/theme/app_theme.dart';
import 'package:clock_app/shared/theme/theme_preference.dart';
import 'package:clock_app/shared/settings_preference.dart';

class SettingsScreen extends StatefulWidget {
  final void Function(AppThemeMode? themeMode)? onThemeChanged;
  final void Function(String? themeColor)? onThemeColorChanged;

  const SettingsScreen({super.key, this.onThemeChanged, this.onThemeColorChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _themePref = ThemePreference.instance;
  final _settingsPref = SettingsPreference.instance;
  AppThemeMode _themeMode = AppThemeMode.system;
  String _themeColor = 'default';
  bool _is24Hour = false;
  String _clockFace = 'digital';
  String _alarmSound = 'system';
  String _timerSound = 'system';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final mode = await _themePref.getThemeMode();
      final color = await _themePref.getThemeColor();
      final is24 = await _settingsPref.is24HourFormat();
      final clockFace = await _settingsPref.getClockFace();
      final alarm = await _settingsPref.getAlarmSound();
      final timer = await _settingsPref.getTimerSound();
      if (mounted) {
        setState(() {
          _themeMode = mode;
          _themeColor = color;
          _is24Hour = is24;
          _clockFace = clockFace;
          _alarmSound = alarm;
          _timerSound = timer;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pop(_themeMode);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(_themeMode),
          ),
        ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(_themeMode == AppThemeMode.system
                ? 'System'
                : _themeMode == AppThemeMode.light
                    ? 'Light'
                    : 'Dark'),
            onTap: () => _showThemePicker(context),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Theme color'),
            subtitle: Text(_themeColorLabel(_themeColor)),
            onTap: () => _showThemeColorPicker(context),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Time format'),
            subtitle: Text(_is24Hour ? '24-hour' : '12-hour'),
            onTap: () => _showTimeFormatPicker(context),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Clock face'),
            subtitle: Text(_clockFace == 'analogue' ? 'Analogue' : 'Digital'),
            onTap: () => _showClockFacePicker(context),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Alarm sound'),
            subtitle: Text(_soundLabel(_alarmSound, isAlarm: true)),
            onTap: () => _showSoundPicker(context, isAlarm: true),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Timer sound'),
            subtitle: Text(_soundLabel(_timerSound, isAlarm: false)),
            onTap: () => _showSoundPicker(context, isAlarm: false),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('About'),
            subtitle: const Text('Clock app 1.0.0'),
            onTap: () => _showAbout(context),
          ),
        ],
      ),
      ),
    );
  }

  String _soundLabel(String key, {required bool isAlarm}) {
    switch (key) {
      case 'system':
        return 'System default';
      case 'sounds/alarm.wav':
        return 'Alarm';
      case 'sounds/timer_end.wav':
        return 'Timer end';
      default:
        return key;
    }
  }

  void _showThemePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('System'),
              onTap: () => _setTheme(ctx, AppThemeMode.system),
            ),
            ListTile(
              title: const Text('Light'),
              onTap: () => _setTheme(ctx, AppThemeMode.light),
            ),
            ListTile(
              title: const Text('Dark'),
              onTap: () => _setTheme(ctx, AppThemeMode.dark),
            ),
          ],
        ),
      ),
    );
  }

  void _showTimeFormatPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('12-hour'),
              onTap: () async {
                await _settingsPref.set24HourFormat(false);
                if (mounted) setState(() => _is24Hour = false);
                if (ctx.mounted) Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('24-hour'),
              onTap: () async {
                await _settingsPref.set24HourFormat(true);
                if (mounted) setState(() => _is24Hour = true);
                if (ctx.mounted) Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClockFacePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Digital'),
              onTap: () async {
                await _settingsPref.setClockFace('digital');
                if (mounted) setState(() => _clockFace = 'digital');
                if (ctx.mounted) Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('Analogue'),
              onTap: () async {
                await _settingsPref.setClockFace('analogue');
                if (mounted) setState(() => _clockFace = 'analogue');
                if (ctx.mounted) Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSoundPicker(BuildContext context, {required bool isAlarm}) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('System default'),
              onTap: () => _setSound(ctx, isAlarm, 'system'),
            ),
            ListTile(
              title: const Text('Alarm'),
              onTap: () => _setSound(ctx, isAlarm, 'sounds/alarm.wav'),
            ),
            ListTile(
              title: const Text('Timer end'),
              onTap: () => _setSound(ctx, isAlarm, 'sounds/timer_end.wav'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setSound(BuildContext ctx, bool isAlarm, String value) async {
    if (isAlarm) {
      await _settingsPref.setAlarmSound(value);
      if (mounted) setState(() => _alarmSound = value);
    } else {
      await _settingsPref.setTimerSound(value);
      if (mounted) setState(() => _timerSound = value);
    }
    if (ctx.mounted) Navigator.pop(ctx);
  }

  Future<void> _setTheme(BuildContext ctx, AppThemeMode mode) async {
    await _themePref.setThemeMode(mode);
    if (mounted) setState(() => _themeMode = mode);
    widget.onThemeChanged?.call(mode);
    if (ctx.mounted) Navigator.pop(ctx, mode);
  }

  String _themeColorLabel(String key) {
    switch (key) {
      case 'blue': return 'Blue';
      case 'green': return 'Green';
      case 'red': return 'Red';
      case 'grey': return 'Grey';
      default: return 'Default';
    }
  }

  void _showThemeColorPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: const Text('Default'), onTap: () => _setThemeColor(ctx, 'default')),
            ListTile(title: const Text('Blue'), onTap: () => _setThemeColor(ctx, 'blue')),
            ListTile(title: const Text('Green'), onTap: () => _setThemeColor(ctx, 'green')),
            ListTile(title: const Text('Red'), onTap: () => _setThemeColor(ctx, 'red')),
            ListTile(title: const Text('Grey'), onTap: () => _setThemeColor(ctx, 'grey')),
          ],
        ),
      ),
    );
  }

  Future<void> _setThemeColor(BuildContext ctx, String value) async {
    await _themePref.setThemeColor(value);
    if (mounted) setState(() => _themeColor = value);
    widget.onThemeColorChanged?.call(value);
    if (ctx.mounted) Navigator.pop(ctx);
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Clock',
      applicationVersion: '1.0.0',
      applicationLegalese: 'Clock, Timer, Alarm, Stopwatch.',
    );
  }
}
