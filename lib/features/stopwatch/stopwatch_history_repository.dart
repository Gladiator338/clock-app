import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clock_app/features/stopwatch/stopwatch_run_model.dart';

const _key = 'clock_app_stopwatch_run_history';
const _maxEntries = 50;

class StopwatchHistoryRepository {
  StopwatchHistoryRepository._();
  static final instance = StopwatchHistoryRepository._();

  Future<List<StopwatchRunRecord>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => StopwatchRunRecord.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> add(StopwatchRunRecord record) async {
    final list = await getAll();
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
