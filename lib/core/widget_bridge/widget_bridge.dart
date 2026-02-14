import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

/// Sends clock data to the native home screen widget.
/// Native widget (iOS WidgetKit / Android App Widget) must be implemented
/// and configured with the same [iOSName] and [qualifiedAndroidName].
class WidgetBridge {
  WidgetBridge._();
  static final instance = WidgetBridge._();

  static const _iosName = 'ClockWidget';
  static const _androidName = 'ClockWidgetProvider';

  /// Update home widget with current time and date. No-op on web.
  Future<void> updateClockWidget({required String time, required String date}) async {
    if (kIsWeb) return;
    try {
      await HomeWidget.saveWidgetData<String>('clock_time', time);
      await HomeWidget.saveWidgetData<String>('clock_date', date);
      await HomeWidget.updateWidget(
        name: _androidName,
        iOSName: _iosName,
      );
    } catch (_) {
      // Native widget may not be added yet
    }
  }
}
