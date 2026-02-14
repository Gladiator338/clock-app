# Scope

What is in scope and out of scope for this project. Update this file when scope changes.

## In scope

- **Platforms**: Android, iOS; web as a secondary target (run/debug).
- **Core features**: Clock (current time/date), Timer (countdown + loud sound at end), Alarm (list, add/edit/delete, scheduled notifications, loud ringtone), Stopwatch (laps, persistence).
- **UI**: Expressive, minimalistic theme; light, dark, and system theme; theme persistence.
- **Sound**: Loud alarm/timer sounds (e.g. `asAlarm: true` where supported); dismiss to stop.
- **Persistence**: Timer end time, alarm list, stopwatch start/laps, theme preference (via `shared_preferences` or equivalent).
- **Timer history**: List of past timer runs (duration, completed or cancelled).
- **Stopwatch**: Persist current run and list of previous runs (duration + laps).
- **Notifications**: Local notifications for timer end and alarm fire; tap to open app / dismiss.
- **Home screen widgets**: Data bridge from Flutter to native widgets (Clock; optional Timer, Alarm, Stopwatch). Native widget UI implemented in platform code (SwiftUI / Kotlin).
- **Dynamic Island / Live Activities** (iOS): Optional; live timer/stopwatch/alarm in Dynamic Island when supported (native SwiftUI).
- **Settings**: Theme picker, About; optional later: default ringtone, volume note.

## Out of scope (unless explicitly added)

- Backend or cloud sync (alarms/timer are device-only).
- Multiple user accounts or login.
- Social or sharing features.
- WatchOS / Wear OS apps.
- Custom font files (use system fonts).
- Paid or in-app purchase features (unless later scoped).

## Boundaries

- **Clock**: Display only; no world-time or time-zone management in initial scope (can be added later).
- **Alarm**: Single recurrence model (e.g. daily) in initial scope; no complex repeat rules unless scoped.
- **Widgets**: Flutter sends data; layout and rendering are native. No Flutter-rendered widget UI.
- **Web**: Supported for run/debug; alarm/timer sounds and native widgets do not apply on web.
