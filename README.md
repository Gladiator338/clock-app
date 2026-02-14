# Clock App

A minimalistic, expressive clock app for Android and iOS with Clock, Timer, Alarm, and Stopwatch.

## Before making changes

**Refer to the [docs/](docs/README.md) folder** for:

- **Scope** ([docs/SCOPE.md](docs/SCOPE.md)) – what is in/out of scope
- **Decisions** ([docs/DECISIONS.md](docs/DECISIONS.md)) – architecture and development decisions
- **Features** ([docs/FEATURES.md](docs/FEATURES.md)) – implemented and planned features
- **Notation** ([docs/NOTATION.md](docs/NOTATION.md)) – naming and conventions

Update the relevant doc when you change scope, take a new decision, add a feature, or introduce a convention.

---

## Setup

1. **Install Flutter** from [flutter.dev](https://flutter.dev) and ensure `flutter` is on your PATH.

2. **Generate platform folders** (if they are missing):
   ```bash
   cd clock-app
   flutter create . --org com.clockapp
   ```

3. **Install dependencies**:
   ```bash
   flutter pub get
   ```

4. **Run the app**:
   ```bash
   flutter run
   ```

## Features

- **Clock** – Current time and date; pushes data to home widget (when native widget is added)
- **Timer** – Countdown with loud sound at end; persists across app close
- **Alarm** – Set alarms with repeat and labels; loud ringtone; scheduled notifications
- **Stopwatch** – Lap times and persistence across app close
- **Settings** – Theme picker (System / Light / Dark), About

UI uses an expressive, minimalistic theme. Theme choice is saved and applied app-wide.

## Home screen widgets

The app sends clock time/date to the `home_widget` bridge. To show a widget on the home screen you must add a native widget extension:

- **iOS**: Add a Widget Extension (WidgetKit) in Xcode, name it `ClockWidget`, and read from the same App Group / UserDefaults keys (`clock_time`, `clock_date`) that `HomeWidget.saveWidgetData` uses.
- **Android**: Add an App Widget that uses `ClockWidgetProvider` and reads from the data layer provided by `home_widget`.

See the [home_widget](https://pub.dev/packages/home_widget) package docs for native setup.
