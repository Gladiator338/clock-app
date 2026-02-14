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

  static TimerRunRecord fromJson(Map<String, dynamic> json) {
    return TimerRunRecord(
      durationSeconds: json['durationSeconds'] as int,
      endTimestamp: DateTime.fromMillisecondsSinceEpoch(json['endTimestamp'] as int),
      completed: json['completed'] as bool? ?? true,
    );
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
