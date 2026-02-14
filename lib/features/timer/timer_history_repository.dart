import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clock_app/features/timer/timer_run_model.dart';

const _key = 'clock_app_timer_history';
const _maxEntries = 50;

class TimerHistoryRepository {
  TimerHistoryRepository._();
  static final instance = TimerHistoryRepository._();

  Future<List<TimerRunRecord>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => TimerRunRecord.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> add(TimerRunRecord record) async {
    final list = await getAll();
    if (list.isNotEmpty && list.first.durationSeconds == record.durationSeconds) return;
    list.insert(0, record);
    final capped = list.take(_maxEntries).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(capped.map((e) => e.toJson()).toList()));
  }

  Future<void> removeAt(int index) async {
    final list = await getAll();
    if (index < 0 || index >= list.length) return;
    list.removeAt(index);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(list.map((e) => e.toJson()).toList()));
  }
}
