import 'package:flutter/material.dart';
import 'package:clock_app/features/stopwatch/stopwatch_run_model.dart';

class StopwatchRunDetailScreen extends StatelessWidget {
  final StopwatchRunRecord record;

  const StopwatchRunDetailScreen({super.key, required this.record});

  String _formatLap(int ms) {
    final minutes = ms ~/ 60000;
    final seconds = (ms % 60000) ~/ 1000;
    final centis = (ms % 1000) ~/ 10;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${centis.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final laps = record.laps;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Run details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            record.formattedTotal,
            style: theme.textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '${laps.length} lap(s)',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (laps.isEmpty)
            Center(
              child: Text(
                'No laps',
                style: theme.textTheme.bodyMedium,
              ),
            )
          else
            ...List.generate(laps.length, (index) {
              final lapMs = index == 0 ? laps[0] : laps[index] - laps[index - 1];
              return ListTile(
                title: Text('Lap ${index + 1}'),
                trailing: Text(
                  _formatLap(lapMs),
                  style: theme.textTheme.titleMedium,
                ),
              );
            }),
        ],
      ),
    );
  }
}
