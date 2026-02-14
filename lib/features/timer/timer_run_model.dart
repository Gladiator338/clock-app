class TimerRunRecord {
  final int durationSeconds;
  final DateTime endTimestamp;
  final bool completed;

  const TimerRunRecord({
    required this.durationSeconds,
    required this.endTimestamp,
    required this.completed,
  });

  Map<String, dynamic> toJson() => {
        'durationSeconds': durationSeconds,
        'endTimestamp': endTimestamp.millisecondsSinceEpoch,
        'completed': completed,
      };

  static TimerRunRecord? fromJsonSafe(Map<String, dynamic>? json) {
    if (json == null) return null;
    try {
      final durationSeconds = json['durationSeconds'] is int ? json['durationSeconds'] as int : null;
      final endTs = json['endTimestamp'];
      final endMs = endTs is int ? endTs : (endTs is String ? int.tryParse(endTs) : null);
      if (durationSeconds == null || durationSeconds < 0 || endMs == null) return null;
      final endTimestamp = DateTime.fromMillisecondsSinceEpoch(endMs);
      final completed = json['completed'] is bool ? json['completed'] as bool : true;
      return TimerRunRecord(
        durationSeconds: durationSeconds,
        endTimestamp: endTimestamp,
        completed: completed,
      );
    } catch (_) {
      return null;
    }
  }

  static TimerRunRecord fromJson(Map<String, dynamic> json) {
    return fromJsonSafe(json)!;
  }

  String get formattedDuration {
    final h = durationSeconds ~/ 3600;
    final m = (durationSeconds % 3600) ~/ 60;
    final s = durationSeconds % 60;
    if (h > 0) {
      return '${h}h ${m}m ${s}s';
    }
    if (m > 0) {
      return '${m}m ${s}s';
    }
    return '${s}s';
  }
}
