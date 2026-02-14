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

  static AlarmModel fromJson(Map<String, dynamic> json) {
    final repeatDaysRaw = json['repeatDays'];
    List<int> repeatDays = [];
    if (repeatDaysRaw is List<dynamic>) {
      repeatDays = repeatDaysRaw.map((e) => e is int ? e : int.tryParse(e.toString()) ?? 0).where((e) => e >= 1 && e <= 7).toList();
    }
    return AlarmModel(
      id: json['id'] as String,
      hour: json['hour'] as int,
      minute: json['minute'] as int,
      label: json['label'] as String?,
      enabled: json['enabled'] as bool? ?? true,
      repeatType: json['repeatType'] as String? ?? 'once',
      repeatDays: repeatDays,
    );
  }
}
