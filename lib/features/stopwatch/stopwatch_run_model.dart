class StopwatchRunRecord {
  final int totalMillis;
  final List<int> laps;

  const StopwatchRunRecord({
    required this.totalMillis,
    required this.laps,
  });

  Map<String, dynamic> toJson() => {
        'totalMillis': totalMillis,
        'laps': laps,
      };

  static StopwatchRunRecord? fromJsonSafe(Map<String, dynamic>? json) {
    if (json == null) return null;
    try {
      final totalMillis = json['totalMillis'] is int ? json['totalMillis'] as int : null;
      if (totalMillis == null || totalMillis < 0) return null;
      final lapsList = json['laps'];
      List<int> laps = [];
      if (lapsList is List<dynamic>) {
        laps = lapsList
            .map((e) => e is int ? e : (e is String ? int.tryParse(e) : null))
            .where((e) => e != null && e >= 0)
            .cast<int>()
            .toList();
      }
      return StopwatchRunRecord(totalMillis: totalMillis, laps: laps);
    } catch (_) {
      return null;
    }
  }

  static StopwatchRunRecord fromJson(Map<String, dynamic> json) {
    return fromJsonSafe(json)!;
  }

  String get formattedTotal {
    final ms = totalMillis;
    final minutes = ms ~/ 60000;
    final seconds = (ms % 60000) ~/ 1000;
    final centis = (ms % 1000) ~/ 10;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${centis.toString().padLeft(2, '0')}';
  }
}
