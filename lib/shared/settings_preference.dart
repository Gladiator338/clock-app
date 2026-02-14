import 'package:shared_preferences/shared_preferences.dart';

const _keyTimeFormat24 = 'clock_app_time_format_24';
const _keyClockFace = 'clock_app_clock_face';
const _keyAlarmSound = 'clock_app_alarm_sound';
const _keyTimerSound = 'clock_app_timer_sound';

/// User preferences for time format and sounds.
class SettingsPreference {
  SettingsPreference._();
  static final instance = SettingsPreference._();

  Future<bool> is24HourFormat() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyTimeFormat24) ?? false;
  }

  Future<void> set24HourFormat(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyTimeFormat24, value);
  }

  /// Clock face: 'digital' or 'analogue'
  Future<String> getClockFace() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyClockFace) ?? 'digital';
  }

  Future<void> setClockFace(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyClockFace, value);
  }

  /// Alarm sound key: 'system' or asset name e.g. 'sounds/alarm.wav'
  Future<String> getAlarmSound() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAlarmSound) ?? 'system';
  }

  Future<void> setAlarmSound(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAlarmSound, value);
  }

  /// Timer sound key: 'system' or asset name e.g. 'sounds/timer_end.wav'
  Future<String> getTimerSound() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyTimerSound) ?? 'system';
  }

  Future<void> setTimerSound(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTimerSound, value);
  }
}
