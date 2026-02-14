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

  static StopwatchRunRecord fromJson(Map<String, dynamic> json) {
    final lapsList = json['laps'] as List<dynamic>?;
    return StopwatchRunRecord(
      totalMillis: json['totalMillis'] as int,
      laps: lapsList?.map((e) => e as int).toList() ?? [],
    );
  }

  String get formattedTotal {
    final ms = totalMillis;
    final minutes = ms ~/ 60000;
    final seconds = (ms % 60000) ~/ 1000;
    final centis = (ms % 1000) ~/ 10;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${centis.toString().padLeft(2, '0')}';
  }
}
