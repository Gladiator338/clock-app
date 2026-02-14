# Development decisions

Record of significant development and architecture decisions. Update when a new decision is made or an existing one is changed.

## Stack and structure

- **Framework**: Flutter (single codebase for Android and iOS).
- **State**: Local state in widgets (`State`); no global state package unless complexity demands it.
- **Persistence**: `shared_preferences` for theme, timer end time, stopwatch, alarm list (JSON). No database unless we outgrow this.
- **Project layout**: Feature-based under `lib/features/` (clock, timer, alarm, stopwatch, settings); `lib/core/` for shared services (audio, notifications, widget_bridge); `lib/shared/` for theme and app-wide utilities.

## UI and theme

- **Theme**: Centralized in `lib/shared/theme/` (AppTheme, AppColors, AppTypography). At least light and dark; theme mode (system/light/dark) persisted.
- **Navigation**: Single main screen with bottom nav (Clock, Timer, Alarm, Stopwatch). Settings opened via app bar action (push route).
- **Style**: Expressive and minimalistic; strong typography for time/numbers; restrained palette; no custom font assets initially.

## Features

- **Timer**: Persist end timestamp; recompute remaining on launch; on end: show notification and play ringtone loop until user dismisses. Timer history: store list of { durationSeconds, endTimestamp, completed } in shared_preferences; append on timer end or cancel; cap size (e.g. 50).
- **Alarm**: Model (id, hour, minute, label?, enabled); repository saves JSON list; schedule via `flutter_local_notifications` (zonedSchedule); ringtone with `asAlarm: true` on fire.
- **Stopwatch**: Persist start timestamp and laps; recompute elapsed on launch; laps stored as list of millisecond values. On reset, append current run (totalMillis, laps) to history list; cap size.
- **Clock**: Updates every second in UI; home widget data sent at most once per minute.

## Platform and plugins

- **Sounds**: `flutter_ringtone_player` with `asAlarm: true` for alarm/timer end.
- **Notifications**: `flutter_local_notifications`; timezone via `timezone` + `flutter_timezone` for scheduled alarms.
- **Widgets**: `home_widget` to save data and trigger update; widget name/IDs: iOS `ClockWidget`, Android `ClockWidgetProvider`; data keys e.g. `clock_time`, `clock_date`.
- **Web**: Notifications and ringtone no-op on web via `kIsWeb`; alarm and timer persistence and UI work on web. Sound and scheduled notifications are mobile-only.

## Conventions

- **Dart**: Follow `flutter_lints`; prefer const where possible.
- **Naming**: Screens: `*_screen.dart`; models: `*_model.dart`; repositories: `*_repository.dart`; services: singletons in `core/` (e.g. `RingtoneService.instance`).
- **Tests**: At least one smoke test (app loads, bottom nav visible); update when app structure changes.
