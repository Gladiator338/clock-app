import 'dart:async';
import 'package:flutter/material.dart';
import 'package:clock_app/features/stopwatch/stopwatch_run_model.dart';
import 'package:clock_app/features/stopwatch/stopwatch_history_repository.dart';
import 'package:clock_app/features/stopwatch/stopwatch_run_detail_screen.dart';
import 'package:clock_app/shared/confirm_dialog.dart';
import 'package:clock_app/shared/preferences_holder.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  static const _prefKeyStartEpoch = 'stopwatch_start_epoch_ms';
  static const _prefKeyLaps = 'stopwatch_laps';

  int _elapsedMillis = 0;
  Timer? _timer;
  bool _running = false;
  final List<int> _laps = [];
  List<StopwatchRunRecord> _previousRuns = [];

  @override
  void initState() {
    super.initState();
    _restore();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final list = await StopwatchHistoryRepository.instance.getAll();
    if (mounted) setState(() => _previousRuns = list);
  }

  Future<void> _deleteHistoryAt(int index) async {
    final ok = await showConfirmDialog(context, title: 'Delete this run?');
    if (ok == true && mounted) {
      await StopwatchHistoryRepository.instance.removeAt(index);
      await _loadHistory();
    }
  }

  Future<void> _restore() async {
    final prefs = await PreferencesHolder.instance.prefs;
    final startEpoch = prefs.getInt(_prefKeyStartEpoch);
    final lapsRaw = prefs.getStringList(_prefKeyLaps);
    if (lapsRaw != null) {
      setState(() {
        _laps.addAll(lapsRaw.map((e) => int.tryParse(e) ?? 0).where((e) => e > 0));
      });
    }
    if (startEpoch != null && _running == false) {
      final start = DateTime.fromMillisecondsSinceEpoch(startEpoch);
      final elapsed = DateTime.now().difference(start).inMilliseconds;
      if (elapsed >= 0) {
        setState(() => _elapsedMillis = elapsed);
        _startTicker();
        setState(() => _running = true);
      } else {
        await prefs.remove(_prefKeyStartEpoch);
      }
    }
  }

  void _startTicker() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!mounted) return;
      setState(() => _elapsedMillis += 100);
    });
  }

  Future<void> _persistStart() async {
    final prefs = await PreferencesHolder.instance.prefs;
    final start = DateTime.now().subtract(Duration(milliseconds: _elapsedMillis));
    await prefs.setInt(_prefKeyStartEpoch, start.millisecondsSinceEpoch);
  }

  Future<void> _clearPersist() async {
    final prefs = await PreferencesHolder.instance.prefs;
    await prefs.remove(_prefKeyStartEpoch);
    await prefs.remove(_prefKeyLaps);
  }

  void _start() {
    if (_elapsedMillis == 0) {
      setState(() => _laps.clear());
      _clearPersist();
    }
    setState(() => _running = true);
    _startTicker();
    _persistStart();
  }

  void _pause() {
    _timer?.cancel();
    setState(() => _running = false);
    _persistStart();
  }

  void _lap() {
    setState(() => _laps.add(_elapsedMillis));
    PreferencesHolder.instance.prefs.then((prefs) {
      prefs.setStringList(
        _prefKeyLaps,
        _laps.map((e) => e.toString()).toList(),
      );
    });
  }

  void _reset() async {
    if (_elapsedMillis > 0 || _laps.isNotEmpty) {
      await StopwatchHistoryRepository.instance.add(StopwatchRunRecord(
        totalMillis: _elapsedMillis,
        laps: List.from(_laps),
      ));
      await _loadHistory();
    }
    _timer?.cancel();
    setState(() {
      _elapsedMillis = 0;
      _running = false;
      _laps.clear();
    });
    _clearPersist();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formatted {
    final ms = _elapsedMillis;
    final hours = ms ~/ 3600000;
    final minutes = (ms % 3600000) ~/ 60000;
    final seconds = (ms % 60000) ~/ 1000;
    final centis = (ms % 1000) ~/ 10;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${centis.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${centis.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 48),
              Text(
                _formatted,
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w200,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_running) ...[
                    FilledButton(
                      onPressed: _elapsedMillis > 0 ? _start : _start,
                      child: Text(_elapsedMillis > 0 ? 'Resume' : 'Start'),
                    ),
                    if (_elapsedMillis > 0) ...[
                      const SizedBox(width: 16),
                      OutlinedButton(
                        onPressed: _reset,
                        child: const Text('Reset'),
                      ),
                    ],
                  ] else ...[
                    OutlinedButton(
                      onPressed: _pause,
                      child: const Text('Pause'),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton(
                      onPressed: _lap,
                      child: const Text('Lap'),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 32),
              Expanded(
                child: _laps.isEmpty && _previousRuns.isEmpty
                    ? Center(
                        child: Text(
                          'Laps will appear here',
                          style: theme.textTheme.bodyMedium,
                        ),
                      )
                    : ListView(
                        children: [
                          if (_laps.isNotEmpty)
                            ...List.generate(_laps.length, (index) {
                              final lapMs = index == 0 ? _laps[0] : _laps[index] - _laps[index - 1];
                              final lapStr = _formatLap(lapMs);
                              return ListTile(
                                title: Text('Lap ${index + 1}'),
                                trailing: Text(
                                  lapStr,
                                  style: theme.textTheme.titleMedium,
                                ),
                              );
                            }),
                          if (_previousRuns.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text('Previous runs', style: theme.textTheme.titleMedium),
                            const SizedBox(height: 4),
                            ..._previousRuns.asMap().entries.map((e) {
                              final i = e.key;
                              final r = e.value;
                              return ListTile(
                                title: Text(r.formattedTotal),
                                subtitle: Text('${r.laps.length} lap(s)'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => _deleteHistoryAt(i),
                                ),
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => StopwatchRunDetailScreen(record: r),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatLap(int ms) {
    final minutes = ms ~/ 60000;
    final seconds = (ms % 60000) ~/ 1000;
    final centis = (ms % 1000) ~/ 10;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${centis.toString().padLeft(2, '0')}';
  }
}
