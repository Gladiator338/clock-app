# Project features

Implemented and planned features. Update when a feature is added, removed, or its status changes.

## Implemented

| Feature | Description | Location / notes |
|--------|-------------|------------------|
| **Clock** | Current time and date (digital); updates every second | `lib/features/clock/clock_screen.dart` |
| **Timer** | Countdown (hours/minutes/seconds); start/pause/reset; persists end time; loud sound + notification at end; dismiss to stop; history of completed/cancelled runs | `lib/features/timer/timer_screen.dart`, `core/audio`, `core/notifications` |
| **Alarm** | List, add, edit, delete; hour/minute, label, on/off; persistence; scheduled local notification; loud ringtone on fire | `lib/features/alarm/`, `core/notifications` |
| **Stopwatch** | Start/pause/reset, laps; persists start time and lap list; on reset, current run appended to previous runs list | `lib/features/stopwatch/stopwatch_screen.dart` |
| **Theme** | Light, dark, system; persisted; applied app-wide | `lib/shared/theme/`, `lib/features/settings/` |
| **Settings** | Theme picker (bottom sheet), About dialog; opened from app bar | `lib/features/settings/settings_screen.dart` |
| **Widget data (Clock)** | Time and date sent to home widget once per minute; native widget must be implemented separately | `lib/core/widget_bridge/widget_bridge.dart`, clock screen |

## Planned / optional (refer to SCOPE)

- Native home screen widget UIs (iOS WidgetKit, Android App Widget) for Clock (and optionally Timer, Alarm, Stopwatch).
- Dynamic Island / Live Activities (iOS) for timer, stopwatch, alarm ringing.
- Notification tap: open app and stop ringtone (notification response handling).
- Optional: default ringtone choice, volume note in settings.
- Optional: world clocks or time zones for Clock.

## Not in scope (see SCOPE.md)

- Backend, cloud sync, multi-user, social, WatchOS/Wear OS, custom font files, IAP (unless later scoped).
