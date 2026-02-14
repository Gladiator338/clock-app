import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:clock_app/core/audio/ringtone_service.dart';
import 'package:clock_app/core/notifications/notification_service.dart';
import 'package:clock_app/features/timer/timer_run_model.dart';
import 'package:clock_app/features/timer/timer_history_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  static const _prefKeyEndTime = 'timer_end_time_epoch_ms';

  int _remainingSeconds = 0;
  int _lastRunTotalSeconds = 0;
  Timer? _tickTimer;
  bool _isRunning = false;
  bool _isRinging = false;
  List<TimerRunRecord> _history = [];

  @override
  void initState() {
    super.initState();
    _loadPersisted();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final list = await TimerHistoryRepository.instance.getAll();
    if (mounted) setState(() => _history = list);
  }

  Future<void> _deleteHistoryAt(int index) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this timer run?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      await TimerHistoryRepository.instance.removeAt(index);
      await _loadHistory();
    }
  }

  Future<void> _loadPersisted() async {
    final prefs = await SharedPreferences.getInstance();
    final endMs = prefs.getInt(_prefKeyEndTime);
    if (endMs != null) {
      final end = DateTime.fromMillisecondsSinceEpoch(endMs);
      final now = DateTime.now();
      if (end.isAfter(now)) {
        setState(() {
          _remainingSeconds = end.difference(now).inSeconds;
          _isRunning = true;
        });
        _startTicker();
      } else {
        await prefs.remove(_prefKeyEndTime);
      }
    }
  }

  void _startTicker() {
    _tickTimer?.cancel();
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_remainingSeconds <= 1) {
          _remainingSeconds = 0;
          _isRunning = false;
          _tickTimer?.cancel();
          _onTimerEnd();
        } else {
          _remainingSeconds--;
        }
      });
    });
  }

  Future<void> _onTimerEnd() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKeyEndTime);
    setState(() => _isRinging = true);
    if (!kIsWeb) {
      await NotificationService.instance.showTimerEndNotification();
      await RingtoneService.instance.playAlarmLoop(isTimer: true);
    }
  }

  Future<void> _persistEndTime(DateTime end) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKeyEndTime, end.millisecondsSinceEpoch);
  }

  void _start(int hours, int minutes, int seconds) {
    final total = hours * 3600 + minutes * 60 + seconds;
    if (total <= 0) return;
    _lastRunTotalSeconds = total;
    TimerHistoryRepository.instance.add(TimerRunRecord(
      durationSeconds: total,
      endTimestamp: DateTime.now(),
      completed: true,
    )).then((_) => _loadHistory());
    final end = DateTime.now().add(Duration(seconds: total));
    _persistEndTime(end);
    setState(() {
      _remainingSeconds = total;
      _isRunning = true;
    });
    _startTicker();
  }

  void _pause() {
    _tickTimer?.cancel();
    setState(() => _isRunning = false);
    final end = DateTime.now().add(Duration(seconds: _remainingSeconds));
    _persistEndTime(end);
  }

  void _resume() {
    setState(() => _isRunning = true);
    _startTicker();
  }

  void _reset() async {
    _tickTimer?.cancel();
    setState(() {
      _remainingSeconds = 0;
      _isRunning = false;
      _isRinging = false;
    });
    SharedPreferences.getInstance().then((prefs) => prefs.remove(_prefKeyEndTime));
    RingtoneService.instance.stop();
  }

  Future<void> _dismissRinging() async {
    await RingtoneService.instance.stop();
    await NotificationService.instance.cancelTimerNotification();
    setState(() => _isRinging = false);
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    super.dispose();
  }

  String get _formatted {
    final h = _remainingSeconds ~/ 3600;
    final m = (_remainingSeconds % 3600) ~/ 60;
    final s = _remainingSeconds % 60;
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isRinging) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Timer done', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _dismissRinging,
                  child: const Text('Dismiss'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final canStart = _remainingSeconds == 0;
    final showPicker = canStart;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 32),
              if (showPicker)
                _TimerPicker(
                  onStart: (h, m, s) => _start(h, m, s),
                )
              else ...[
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
                    FilledButton(
                      onPressed: _isRunning ? _pause : _resume,
                      child: Text(_isRunning ? 'Pause' : 'Resume'),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton(
                      onPressed: _reset,
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
              if (_history.isNotEmpty) ...[
                const SizedBox(height: 32),
                Text('History', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: _history.length,
                    itemBuilder: (context, i) {
                      final r = _history[i];
                      final h = r.durationSeconds ~/ 3600;
                      final m = (r.durationSeconds % 3600) ~/ 60;
                      final s = r.durationSeconds % 60;
                      return ListTile(
                        title: Text(r.formattedDuration),
                        subtitle: Text('Started • ${_formatDate(r.endTimestamp)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _deleteHistoryAt(i),
                        ),
                        onTap: () => _start(h, m, s),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(dt.year, dt.month, dt.day);
    if (d == today) {
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    return '${dt.month}/${dt.day}';
  }
}

class _TimerPicker extends StatefulWidget {
  final void Function(int hours, int minutes, int seconds) onStart;

  const _TimerPicker({required this.onStart});

  @override
  State<_TimerPicker> createState() => _TimerPickerState();
}

class _TimerPickerState extends State<_TimerPicker> {
  Duration _duration = const Duration(minutes: 5);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hms,
            initialTimerDuration: _duration,
            onTimerDurationChanged: (d) => setState(() => _duration = d),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          '${_duration.inHours.toString().padLeft(2, '0')}:${(_duration.inMinutes % 60).toString().padLeft(2, '0')}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () => widget.onStart(
            _duration.inHours,
            _duration.inMinutes % 60,
            _duration.inSeconds % 60,
          ),
          child: const Text('Start'),
        ),
      ],
    );
  }
}

