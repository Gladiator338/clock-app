import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clock_app/features/alarm/alarm_model.dart';
import 'package:clock_app/features/alarm/alarm_repository.dart';
import 'package:clock_app/core/notifications/notification_service.dart';
import 'package:clock_app/shared/settings_preference.dart';

final _alarmRepo = AlarmRepository();

String _formatAlarmTime(int hour, int minute, bool is24Hour) {
  if (is24Hour) {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
  final h = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
  final period = hour < 12 ? 'AM' : 'PM';
  return '${h.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
}

const List<String> _weekdayShort = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

String _repeatSummary(AlarmModel alarm) {
  if (alarm.repeatType == 'once') return 'Once';
  if (alarm.repeatType == 'daily') return 'Daily';
  if (alarm.repeatType == 'weekdays' && alarm.repeatDays.isNotEmpty) {
    return alarm.repeatDays.map((d) => _weekdayShort[d - 1]).join(', ');
  }
  return 'Once';
}

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  List<AlarmModel> _alarms = [];
  bool _loading = true;
  bool _is24Hour = false;

  @override
  void initState() {
    super.initState();
    _load();
    SettingsPreference.instance.is24HourFormat().then((v) {
      if (mounted) setState(() => _is24Hour = v);
    });
  }

  Future<void> _load() async {
    final list = await _alarmRepo.getAll();
    if (mounted) setState(() {
      _alarms = list;
      _loading = false;
    });
  }

  Future<void> _toggle(AlarmModel alarm) async {
    final updated = alarm.copyWith(enabled: !alarm.enabled);
    await _alarmRepo.save(updated);
    if (updated.enabled) {
      await NotificationService.instance.scheduleAlarm(updated);
    } else {
      await NotificationService.instance.cancelAlarm(updated.id);
    }
    _load();
  }

  Future<void> _addAlarm() async {
    final result = await Navigator.of(context).push<AlarmModel?>(
      PageRouteBuilder<AlarmModel?>(
        pageBuilder: (_, __, ___) => AlarmEditScreen(is24Hour: _is24Hour),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.03),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 280),
      ),
    );
    if (result != null) {
      await _alarmRepo.save(result);
      if (result.enabled) {
        await NotificationService.instance.scheduleAlarm(result);
      }
      _load();
    } else {
      _load();
    }
  }

  Future<void> _editAlarm(AlarmModel alarm) async {
    final result = await Navigator.of(context).push<AlarmModel?>(
      PageRouteBuilder<AlarmModel?>(
        pageBuilder: (_, __, ___) => AlarmEditScreen(alarm: alarm, is24Hour: _is24Hour),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.03),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 280),
      ),
    );
    if (result != null) {
      await _alarmRepo.save(result);
      await NotificationService.instance.cancelAlarm(alarm.id);
      if (result.enabled) {
        await NotificationService.instance.scheduleAlarm(result);
      }
      _load();
    } else {
      _load();
    }
  }

  Future<void> _deleteAlarm(AlarmModel alarm) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this alarm?'),
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
      await _alarmRepo.delete(alarm.id);
      await NotificationService.instance.cancelAlarm(alarm.id);
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        switchInCurve: Curves.easeOut,
        child: _loading
            ? const Center(key: ValueKey('loading'), child: CircularProgressIndicator())
            : _alarms.isEmpty
              ? Center(
                  key: const ValueKey('empty'),
                  child: FilledButton.icon(
                    onPressed: _addAlarm,
                    icon: const Icon(Icons.add),
                    label: const Text('Add alarm'),
                  ),
                )
              : Column(
                  key: const ValueKey('list'),
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: _alarms.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final alarm = _alarms[index];
                          final time = _formatAlarmTime(alarm.hour, alarm.minute, _is24Hour);
                          final subtitle = alarm.label?.isNotEmpty == true
                              ? '${alarm.label!} • ${_repeatSummary(alarm)}'
                              : _repeatSummary(alarm);
                          return ListTile(
                            onTap: () => _editAlarm(alarm),
                            title: Text(
                              time,
                              style: theme.textTheme.headlineMedium,
                            ),
                            subtitle: Text(subtitle),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Switch(
                                  value: alarm.enabled,
                                  onChanged: (_) => _toggle(alarm),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => _deleteAlarm(alarm),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: FilledButton.icon(
                          onPressed: _addAlarm,
                          icon: const Icon(Icons.add),
                          label: const Text('Add alarm'),
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}

class AlarmEditScreen extends StatefulWidget {
  final AlarmModel? alarm;
  final bool is24Hour;

  const AlarmEditScreen({super.key, this.alarm, this.is24Hour = false});

  @override
  State<AlarmEditScreen> createState() => _AlarmEditScreenState();
}

class _AlarmEditScreenState extends State<AlarmEditScreen> {
  late int _hour;
  late int _minute;
  late bool _enabled;
  late bool _repeatOn;
  late String _repeatType;
  late List<int> _repeatDays;
  late TextEditingController _labelController;

  static const List<int> _weekdayOrder = [1, 2, 3, 4, 5, 6, 7];
  static const List<String> _weekdayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    if (widget.alarm != null) {
      _hour = widget.alarm!.hour;
      _minute = widget.alarm!.minute;
      _enabled = widget.alarm!.enabled;
      _repeatOn = widget.alarm!.repeatType != 'once';
      _repeatType = widget.alarm!.repeatType;
      _repeatDays = List.from(widget.alarm!.repeatDays);
      _labelController = TextEditingController(text: widget.alarm!.label ?? '');
    } else {
      final n = DateTime.now();
      _hour = n.hour;
      _minute = n.minute;
      _enabled = true;
      _repeatOn = false;
      _repeatType = 'once';
      _repeatDays = [];
      _labelController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  void _save() {
    final label = _labelController.text.trim();
    final repeatType = _repeatOn ? _repeatType : 'once';
    final repeatDays = _repeatOn && _repeatType == 'weekdays' ? List<int>.from(_repeatDays) : <int>[];
    final model = AlarmModel(
      id: widget.alarm?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      hour: _hour,
      minute: _minute,
      label: label.isEmpty ? null : label,
      enabled: _enabled,
      repeatType: repeatType,
      repeatDays: repeatDays,
    );
    Navigator.of(context).pop<AlarmModel?>(model);
  }

  Future<void> _confirmDelete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete alarm?'),
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
    if (ok == true && mounted && widget.alarm != null) {
      await _alarmRepo.delete(widget.alarm!.id);
      await NotificationService.instance.cancelAlarm(widget.alarm!.id);
      if (mounted) Navigator.of(context).pop<AlarmModel?>(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.alarm != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit alarm' : 'New alarm'),
        actions: [
          if (isEdit)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _confirmDelete,
            ),
          TextButton(
            onPressed: _save,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 220,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: DateTime(2000, 1, 1, _hour, _minute),
                onDateTimeChanged: (dt) {
                  setState(() {
                    _hour = dt.hour;
                    _minute = dt.minute;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _formatAlarmTime(_hour, _minute, widget.is24Hour),
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Label',
                hintText: 'Alarm',
              ),
              controller: _labelController,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('On'),
              value: _enabled,
              onChanged: (v) => setState(() => _enabled = v),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Repeat'),
              value: _repeatOn,
              onChanged: (v) => setState(() {
                _repeatOn = v;
                if (v && _repeatType == 'once') _repeatType = 'daily';
                if (!v) _repeatType = 'once';
              }),
            ),
            if (_repeatOn) ...[
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'daily', label: Text('Every day'), icon: Icon(Icons.repeat)),
                  ButtonSegment(value: 'weekdays', label: Text('Specific days'), icon: Icon(Icons.calendar_view_week)),
                ],
                selected: {_repeatType == 'once' ? 'daily' : _repeatType},
                onSelectionChanged: (s) => setState(() => _repeatType = s.first),
              ),
              if (_repeatType == 'weekdays') ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _weekdayOrder.asMap().entries.map((e) {
                    final day = e.value;
                    final label = _weekdayLabels[e.key];
                    final selected = _repeatDays.contains(day);
                    return FilterChip(
                      label: Text(label),
                      selected: selected,
                      onSelected: (v) {
                        setState(() {
                          if (v) _repeatDays.add(day);
                          else _repeatDays.remove(day);
                          _repeatDays.sort();
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

