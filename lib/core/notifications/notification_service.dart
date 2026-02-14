import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:clock_app/features/alarm/alarm_model.dart';

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    if (kIsWeb) {
      _initialized = true;
      return;
    }
    tz_data.initializeTimeZones();
    final tzInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(tzInfo.identifier));
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: android, iOS: ios);
    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );
    _initialized = true;
  }

  void _onNotificationResponse(NotificationResponse response) {
    // Could open app to timer/alarm screen or stop ringtone
  }

  static const int _timerEndId = 1;

  Future<void> showTimerEndNotification() async {
    if (kIsWeb) return;
    await init();
    const android = AndroidNotificationDetails(
      'timer_channel',
      'Timer',
      channelDescription: 'Timer completed',
      importance: Importance.max,
      priority: Priority.max,
    );
    const ios = DarwinNotificationDetails();
    const details = NotificationDetails(android: android, iOS: ios);
    await _plugin.show(_timerEndId, 'Timer', 'Timer completed', details);
  }

  Future<void> cancelTimerNotification() async {
    if (kIsWeb) return;
    await _plugin.cancel(_timerEndId);
  }

  static int _notificationIdForAlarm(String alarmId) {
    int h = 0;
    for (int i = 0; i < alarmId.length; i++) {
      h = ((h * 31) + alarmId.codeUnitAt(i)) & 0x7FFFFFFF;
    }
    return h == 0 ? 1 : h;
  }

  Future<void> scheduleAlarm(AlarmModel alarm) async {
    if (kIsWeb) return;
    await init();
    final scheduled = _nextOccurrence(alarm);
    if (scheduled == null) return;
    final id = _notificationIdForAlarm(alarm.id);
    const android = AndroidNotificationDetails(
      'alarm_channel',
      'Alarm',
      channelDescription: 'Alarm',
      importance: Importance.max,
      priority: Priority.max,
    );
    const ios = DarwinNotificationDetails();
    const details = NotificationDetails(android: android, iOS: ios);
    await _plugin.zonedSchedule(
      id,
      'Alarm',
      alarm.label ?? 'Alarm',
      _toTZ(scheduled),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Next occurrence for this alarm based on repeat type.
  DateTime? _nextOccurrence(AlarmModel alarm) {
    final now = DateTime.now();
    var scheduled = DateTime(now.year, now.month, now.day, alarm.hour, alarm.minute);
    if (scheduled.isBefore(now) || scheduled.isAtSameMomentAs(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    switch (alarm.repeatType) {
      case 'once':
        return scheduled;
      case 'daily':
        return scheduled;
      case 'weekdays':
        final days = alarm.repeatDays;
        if (days.isEmpty) return scheduled;
        for (int d = 0; d < 8; d++) {
          final candidate = scheduled.add(Duration(days: d));
          if (days.contains(candidate.weekday)) return candidate;
        }
        return scheduled;
      default:
        return scheduled;
    }
  }

  tz.TZDateTime _toTZ(DateTime dt) {
    return tz.TZDateTime.from(dt, tz.local);
  }

  Future<void> cancelAlarm(String alarmId) async {
    if (kIsWeb) return;
    final id = _notificationIdForAlarm(alarmId);
    await _plugin.cancel(id);
  }
}
