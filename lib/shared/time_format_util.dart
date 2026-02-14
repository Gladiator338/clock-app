/// Formats hour:minute, with optional AM/PM when not 24h.
String formatTimeOfDay(int hour, int minute, bool is24Hour) {
  if (is24Hour) {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
  final h = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
  final period = hour < 12 ? 'AM' : 'PM';
  return '${h.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
}

/// Period only (AM/PM). Empty if 24h.
String formatPeriod(int hour) {
  return hour < 12 ? 'AM' : 'PM';
}

const _weekdays = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
];
const _months = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

/// Formats date as "Weekday, Month d" (e.g. Saturday, February 14).
String formatLongDate(DateTime date) {
  final w = _weekdays[date.weekday - 1];
  final m = _months[date.month - 1];
  return '$w, $m ${date.day}';
}
