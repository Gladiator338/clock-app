import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clock_app/features/alarm/alarm_model.dart';

class AlarmRepository {
  static const _key = 'clock_app_alarms';

  Future<List<AlarmModel>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => AlarmModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> save(AlarmModel alarm) async {
    final list = await getAll();
    final index = list.indexWhere((a) => a.id == alarm.id);
    if (index >= 0) {
      list[index] = alarm;
    } else {
      list.add(alarm);
    }
    await _write(list);
  }

  Future<void> delete(String id) async {
    final list = await getAll();
    list.removeWhere((a) => a.id == id);
    await _write(list);
  }

  Future<void> _write(List<AlarmModel> list) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(list.map((e) => e.toJson()).toList());
    await prefs.setString(_key, raw);
  }
}
