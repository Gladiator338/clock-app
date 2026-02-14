/// Repeat type: once, every day, or specific weekdays.
/// For [weekdays], [repeatDays] holds 1=Mon..7=Sun.
class AlarmModel {
  final String id;
  final int hour;
  final int minute;
  final String? label;
  final bool enabled;
  /// 'once' | 'daily' | 'weekdays'
  final String repeatType;
  /// 1 = Monday .. 7 = Sunday. Used when [repeatType] == 'weekdays'.
  final List<int> repeatDays;

  const AlarmModel({
    required this.id,
    required this.hour,
    required this.minute,
    this.label,
    this.enabled = true,
    this.repeatType = 'once',
    this.repeatDays = const [],
  });

  AlarmModel copyWith({
    String? id,
    int? hour,
    int? minute,
    String? label,
    bool? enabled,
    String? repeatType,
    List<int>? repeatDays,
  }) {
    return AlarmModel(
      id: id ?? this.id,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      label: label ?? this.label,
      enabled: enabled ?? this.enabled,
      repeatType: repeatType ?? this.repeatType,
      repeatDays: repeatDays ?? this.repeatDays,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'hour': hour,
        'minute': minute,
        'label': label,
        'enabled': enabled,
        'repeatType': repeatType,
        'repeatDays': repeatDays,
      };

  static const int maxLabelLength = 100;

  static String? _capLabel(String? s) {
    if (s == null || s.isEmpty) return null;
    final t = s.replaceAll(RegExp(r'[\r\n\t\x00-\x1f]'), ' ').trim();
    if (t.isEmpty) return null;
    return t.length > maxLabelLength ? t.substring(0, maxLabelLength) : t;
  }

  static int? _intInRange(dynamic v, int min, int max) {
    final n = v is int ? v : (v is String ? int.tryParse(v) : null);
    if (n == null || n < min || n > max) return null;
    return n;
  }

  static AlarmModel? fromJsonSafe(Map<String, dynamic>? json) {
    if (json == null) return null;
    try {
      final id = json['id'];
      if (id == null || id is! String || id.isEmpty) return null;
      final hour = _intInRange(json['hour'], 0, 23);
      final minute = _intInRange(json['minute'], 0, 59);
      if (hour == null || minute == null) return null;
      final repeatType = json['repeatType'] is String ? json['repeatType'] as String : 'once';
      if (!['once', 'daily', 'weekdays'].contains(repeatType)) return null;
      final repeatDaysRaw = json['repeatDays'];
      List<int> repeatDays = [];
      if (repeatDaysRaw is List<dynamic>) {
        repeatDays = repeatDaysRaw
            .map((e) => e is int ? e : int.tryParse(e.toString()) ?? 0)
            .where((e) => e >= 1 && e <= 7)
            .toList();
      }
      return AlarmModel(
        id: id,
        hour: hour,
        minute: minute,
        label: _capLabel(json['label'] is String ? json['label'] as String? : null),
        enabled: json['enabled'] is bool ? json['enabled'] as bool : true,
        repeatType: repeatType,
        repeatDays: repeatDays,
      );
    } catch (_) {
      return null;
    }
  }

  static AlarmModel fromJson(Map<String, dynamic> json) {
    return fromJsonSafe(json)!;
  }
}
