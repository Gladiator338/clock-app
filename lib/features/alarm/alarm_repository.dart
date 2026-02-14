import 'dart:convert';
import 'package:clock_app/shared/preferences_holder.dart';
import 'package:clock_app/features/alarm/alarm_model.dart';

class AlarmRepository {
  AlarmRepository._();
  static final instance = AlarmRepository._();

  static const _key = 'clock_app_alarms';

  Future<List<AlarmModel>> getAll() async {
    try {
      final prefs = await PreferencesHolder.instance.prefs;
      final raw = prefs.getString(_key);
      if (raw == null) return [];
      final decoded = jsonDecode(raw);
      if (decoded is! List<dynamic>) return [];
      final list = <AlarmModel>[];
      for (final e in decoded) {
        if (e is Map<String, dynamic>) {
          final model = AlarmModel.fromJsonSafe(e);
          if (model != null) list.add(model);
        }
      }
      return list;
    } catch (_) {
      return [];
    }
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
    final prefs = await PreferencesHolder.instance.prefs;
    final raw = jsonEncode(list.map((e) => e.toJson()).toList());
    await prefs.setString(_key, raw);
  }
}
