import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:clock_app/core/widget_bridge/widget_bridge.dart';
import 'package:clock_app/shared/settings_preference.dart';
import 'package:clock_app/shared/time_format_util.dart';

class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key});

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  late String _time;
  late String _date;
  late String _period;
  bool _is24Hour = false;
  String _clockFace = 'digital';
  int _lastWidgetMinute = -1;

  void _updateTime() {
    final now = DateTime.now();
    final time = formatTimeOfDay(now.hour, now.minute, _is24Hour);
    final period = _is24Hour ? '' : formatPeriod(now.hour);
    final date = formatLongDate(now);
    setState(() {
      _time = time;
      _period = period;
      _date = date;
    });
    if (now.minute != _lastWidgetMinute) {
      _lastWidgetMinute = now.minute;
      WidgetBridge.instance.updateClockWidget(
        time: period.isEmpty ? time : '$time $period',
        date: date,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    SettingsPreference.instance.is24HourFormat().then((v) {
      if (mounted) setState(() => _is24Hour = v);
    });
    SettingsPreference.instance.getClockFace().then((v) {
      if (mounted) setState(() => _clockFace = v);
    });
    _updateTime();
    // Update every second for smooth clock
    Future.delayed(Duration.zero, () {
      if (!mounted) return;
      _tick();
    });
  }

  void _tick() {
    _updateTime();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) _tick();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: _clockFace == 'analogue'
                      ? AnalogueClockFace(key: const ValueKey('analogue'), isDark: isDark)
                      : Row(
                          key: const ValueKey('digital'),
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              _time,
                              style: theme.textTheme.displayLarge?.copyWith(
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                            if (_period.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Text(
                                _period,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: isDark
                                      ? const Color(0xFFA3A3A3)
                                      : const Color(0xFF6B6B6B),
                                ),
                              ),
                            ],
                          ],
                        ),
                ),
                const SizedBox(height: 16),
                Text(
                  _date,
                  style: theme.textTheme.bodyMedium,
                ),
                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Analogue clock face with hour, minute, and second hands.
class AnalogueClockFace extends StatelessWidget {
  final bool isDark;

  const AnalogueClockFace({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return CustomPaint(
      size: const Size(200, 200),
      painter: _AnalogueClockPainter(
        hour: now.hour,
        minute: now.minute,
        second: now.second,
        isDark: isDark,
      ),
    );
  }
}

class _AnalogueClockPainter extends CustomPainter {
  final int hour;
  final int minute;
  final int second;
  final bool isDark;

  _AnalogueClockPainter({
    required this.hour,
    required this.minute,
    required this.second,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2 - 8;

    final facePaint = Paint()
      ..color = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE8E8E8)
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = isDark ? const Color(0xFF5C5C5C) : const Color(0xFF9E9E9E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius, facePaint);
    canvas.drawCircle(center, radius, borderPaint);

    final tickPaint = Paint()
      ..color = isDark ? const Color(0xFFB0B0B0) : const Color(0xFF616161)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 12; i++) {
      final angle = (i * 30 - 90) * math.pi / 180;
      final innerR = radius - 10;
      final outerR = radius;
      canvas.drawLine(
        Offset(center.dx + innerR * math.cos(angle), center.dy + innerR * math.sin(angle)),
        Offset(center.dx + outerR * math.cos(angle), center.dy + outerR * math.sin(angle)),
        tickPaint,
      );
    }

    final hourAngle = ((hour % 12) * 30 + minute / 2 - 90) * math.pi / 180;
    final minuteAngle = (minute * 6 + second / 10 - 90) * math.pi / 180;
    final secondAngle = (second * 6 - 90) * math.pi / 180;

    final handPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    handPaint.strokeWidth = 3;
    handPaint.color = isDark ? const Color(0xFFE0E0E0) : const Color(0xFF212121);
    canvas.drawLine(
      center,
      Offset(center.dx + (radius * 0.45) * math.cos(hourAngle), center.dy + (radius * 0.45) * math.sin(hourAngle)),
      handPaint,
    );

    handPaint.strokeWidth = 2.5;
    canvas.drawLine(
      center,
      Offset(center.dx + (radius * 0.65) * math.cos(minuteAngle), center.dy + (radius * 0.65) * math.sin(minuteAngle)),
      handPaint,
    );

    handPaint.strokeWidth = 1.5;
    handPaint.color = isDark ? const Color(0xFFFF5252) : const Color(0xFFD32F2F);
    canvas.drawLine(
      center,
      Offset(center.dx + (radius * 0.7) * math.cos(secondAngle), center.dy + (radius * 0.7) * math.sin(secondAngle)),
      handPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _AnalogueClockPainter old) {
    return old.hour != hour || old.minute != minute || old.second != second;
  }
}
