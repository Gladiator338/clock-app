# Notations and conventions

Naming, file layout, and conventions used in this project. Follow these when adding or changing code. Update this file when new conventions are adopted.

## File and folder naming

- **Folders**: `snake_case` (e.g. `clock_screen`, `widget_bridge`).
- **Dart files**: `snake_case.dart` (e.g. `alarm_model.dart`, `notification_service.dart`).
- **Feature screens**: `*_screen.dart` (e.g. `clock_screen.dart`, `timer_screen.dart`).
- **Models**: `*_model.dart` (e.g. `alarm_model.dart`).
- **Repositories**: `*_repository.dart` (e.g. `alarm_repository.dart`, `timer_history_repository.dart`).
- **Timer history**: `timer_run_model.dart`, `timer_history_repository.dart`.
- **Stopwatch history**: `stopwatch_run_model.dart`, `stopwatch_history_repository.dart`.
- **Services**: `*_service.dart` (e.g. `ringtone_service.dart`, `notification_service.dart`).
- **Theme**: `app_theme.dart`, `app_colors.dart`, `app_typography.dart`, `theme_preference.dart`.

## Code naming

- **Classes**: `PascalCase` (e.g. `ClockScreen`, `AlarmModel`, `RingtoneService`).
- **Files**: One main public class per file when practical; name file after that class (e.g. `clock_screen.dart` → `ClockScreen`).
- **Private classes**: Prefix with `_` (e.g. `_ClockScreenState`, `_TimerPicker`).
- **Singletons**: `ClassName._();` private constructor + `static final instance = ClassName._();` (e.g. `RingtoneService`, `NotificationService`, `ThemePreference`, `WidgetBridge`).
- **SharedPreferences keys**: Prefix with `clock_app_` or feature (e.g. `clock_app_theme_mode`, `clock_app_alarms`, `timer_end_time_epoch_ms`, `stopwatch_start_epoch_ms`).
- **Widget / home_widget data keys**: Lowercase with underscore (e.g. `clock_time`, `clock_date`).

## Project layout

```
lib/
  main.dart              # Entry; binds Flutter, runs ClockApp
  app.dart                # MaterialApp, bottom nav, theme, settings route
  features/               # Feature modules
    clock/
    timer/
    alarm/                # alarm_screen, alarm_model, alarm_repository
    stopwatch/
    settings/
  core/                   # Shared services and bridges
    audio/
    notifications/
    widget_bridge/
  shared/                 # Theme, constants
    theme/
docs/                     # SCOPE, DECISIONS, FEATURES, NOTATION, this README
```

## Widget and provider names (native)

- **iOS (WidgetKit)**: `ClockWidget` (name used in `HomeWidget.updateWidget(iOSName: ...)`).
- **Android**: `ClockWidgetProvider` (name used in `HomeWidget.updateWidget(name: ...)`).
- Use same names in native widget implementation so updates apply.

## Version and IDs

- **App version**: In `pubspec.yaml` (`version: 1.0.0+1`). Bump when releasing.
- **Notification IDs**: Timer end uses a fixed ID (e.g. `1`); alarms use `alarm.id.hashCode.abs() % 0x7FFFFFFF` for stable, unique IDs.

## References

- Before changing scope: update [SCOPE.md](SCOPE.md).
- After a design/architecture choice: record in [DECISIONS.md](DECISIONS.md).
- When adding/removing a feature: update [FEATURES.md](FEATURES.md).
- When introducing a new convention: add to this file (NOTATION.md).
