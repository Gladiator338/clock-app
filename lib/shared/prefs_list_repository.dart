import 'dart:convert';
import 'package:clock_app/shared/preferences_holder.dart';

/// Generic repository that stores a list of items in SharedPreferences as JSON.
class PrefsListRepository<T> {
  PrefsListRepository({
    required this.key,
    required this.fromJsonSafe,
    required this.toJson,
    required this.maxEntries,
    this.skipAddIfDuplicate,
  });

  final String key;
  final T? Function(Map<String, dynamic> json) fromJsonSafe;
  final Map<String, dynamic> Function(T item) toJson;
  final int maxEntries;
  final bool Function(List<T> current, T newItem)? skipAddIfDuplicate;

  Future<List<T>> getAll() async {
    try {
      final prefs = await PreferencesHolder.instance.prefs;
      final raw = prefs.getString(key);
      if (raw == null) return [];
      final decoded = jsonDecode(raw);
      if (decoded is! List<dynamic>) return [];
      final list = <T>[];
      for (final e in decoded) {
        if (e is Map<String, dynamic>) {
          final item = fromJsonSafe(e);
          if (item != null) list.add(item);
        }
      }
      return list;
    } catch (_) {
      return [];
    }
  }

  Future<void> add(T item) async {
    final list = await getAll();
    if (skipAddIfDuplicate != null && skipAddIfDuplicate!(list, item)) return;
    list.insert(0, item);
    final capped = list.take(maxEntries).toList();
    final prefs = await PreferencesHolder.instance.prefs;
    await prefs.setString(key, jsonEncode(capped.map((e) => toJson(e)).toList()));
  }

  Future<void> removeAt(int index) async {
    final list = await getAll();
    if (index < 0 || index >= list.length) return;
    list.removeAt(index);
    final prefs = await PreferencesHolder.instance.prefs;
    await prefs.setString(key, jsonEncode(list.map((e) => toJson(e)).toList()));
  }
}
