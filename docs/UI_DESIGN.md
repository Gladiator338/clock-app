# UI design

Single source of truth for the clock app UI. When changing the design, update this doc and the mapped implementation files.

---

## 1. Design principles

- **Minimalistic**: Ample whitespace, limited chrome, hierarchy via typography and spacing. No decorative clutter.
- **Expressive**: Strong typography for time and key numbers; subtle motion for state changes; optional light depth (gradient/blur). Personality from type and micro-interactions.
- **Consistent**: One accent, neutrals, and clear semantic states (active vs idle) across light and dark. Same tokens for all features and for native widgets where possible.

See [SCOPE.md](SCOPE.md) and [DECISIONS.md](DECISIONS.md) for scope and theme decisions.

---

## 2. Visual tokens

### Colors

| Role | Light | Dark | Implementation |
|------|-------|------|-----------------|
| Background | `#FAFAFA` | `#0D0D0D` | `AppColors.lightBackground` / `darkBackground` |
| Surface | `#FFFFFF` | `#1A1A1A` | `lightSurface` / `darkSurface` |
| Primary (text) | `#1A1A1A` | `#F5F5F5` | `lightPrimary` / `darkPrimary` |
| Secondary (text) | `#6B6B6B` | `#A3A3A3` | `lightSecondary` / `darkSecondary` |
| Accent | `#2563EB` | `#60A5FA` | `lightAccent` / `darkAccent` |
| Divider | `#E5E5E5` | `#2A2A2A` | `lightDivider` / `darkDivider` |
| Idle (unselected) | `#B4B4B4` | `#525252` | `lightIdle` / `darkIdle` |

**Implementation:** [lib/shared/theme/app_colors.dart](../lib/shared/theme/app_colors.dart)

### Typography

| Style | Use | Size | Weight | Implementation |
|-------|-----|------|--------|-----------------|
| displayLarge | Clock time | 72 | w200 | `Theme.of(context).textTheme.displayLarge` |
| displayMedium | Timer countdown, stopwatch | 48 | w300 | `displayMedium` |
| displaySmall | Picker numbers, colons | 36 | w300 | `displaySmall` |
| headlineMedium | Alarm time, section titles | 24 | w500 | `headlineMedium` |
| titleLarge | Period (AM/PM), list titles | 20 | w500 | `titleLarge` |
| titleMedium | List secondary | 16 | w500 | `titleMedium` |
| bodyLarge | Empty state, primary body | 16 | w400 | `bodyLarge` |
| bodyMedium | Date, labels, secondary | 14 | w400 | `bodyMedium` |
| labelLarge | Buttons, labels | 14 | w600 | `labelLarge` |

**Implementation:** [lib/shared/theme/app_typography.dart](../lib/shared/theme/app_typography.dart), [lib/shared/theme/app_theme.dart](../lib/shared/theme/app_theme.dart) (`textTheme`)

### Spacing

- Screen horizontal padding: **24**
- Section vertical spacing: **16**, **32**, or **48** (between major blocks)
- Between time and date (Clock): **16**
- Between countdown and controls (Timer): **48**

**Implementation:** Inline in each screen (e.g. `padding: EdgeInsets.symmetric(horizontal: 24)`, `SizedBox(height: 32)`).

### Elevation and radius

- No card elevation; flat surfaces. Buttons use theme FilledButton/OutlinedButton defaults. Divider between list items.

**Implementation:** [lib/shared/theme/app_theme.dart](../lib/shared/theme/app_theme.dart) (`elevation: 0` on app bar and bottom nav).

---

## 3. Shell and navigation

- **App bar**: Title = current tab name (Clock, Timer, Alarm, Stopwatch). One action: settings (outline icon). No back on main tabs.
- **Bottom navigation**: Four items with icon + label; selected = accent, unselected = idle; fixed type, no elevation.

**Implementation:** [lib/app.dart](../lib/app.dart) (`AppBar`, `BottomNavigationBar`), [lib/shared/theme/app_theme.dart](../lib/shared/theme/app_theme.dart) (`appBarTheme`, `bottomNavigationBarTheme`).

---

## 4. Screen-by-screen layout

### Clock

- Centered block: time (displayLarge, thin) + period (titleLarge, secondary) on one row; date (bodyMedium) below.
- Horizontal padding 24; spacers for vertical balance.

**Implementation:** [lib/features/clock/clock_screen.dart](../lib/features/clock/clock_screen.dart)

### Timer

- Top: countdown (displayMedium, letterSpacing 2).
- Below: either picker (hr / min / sec with up/down and labels) or Pause/Resume + Cancel.
- Padding 24; vertical spacing 32/48.
- (After feature) History section below with recent runs.

**Implementation:** [lib/features/timer/timer_screen.dart](../lib/features/timer/timer_screen.dart)

### Alarm

- List of tiles: time (headlineMedium), optional label (subtitle), trailing switch. FAB to add. Empty state: message + "Add alarm" button.
- Edit screen: time picker (hour/minute), label field, On switch, Save; delete in app bar.

**Implementation:** [lib/features/alarm/alarm_screen.dart](../lib/features/alarm/alarm_screen.dart)

### Stopwatch

- Elapsed time (displayMedium). Row of actions: Start/Resume, Pause, Lap, Reset. Lap list below.
- (After feature) "Previous runs" section with duration and laps per run.

**Implementation:** [lib/features/stopwatch/stopwatch_screen.dart](../lib/features/stopwatch/stopwatch_screen.dart)

### Settings

- List: Theme (subtitle = current mode), About (subtitle = version). Theme picker: bottom sheet with System / Light / Dark.

**Implementation:** [lib/features/settings/settings_screen.dart](../lib/features/settings/settings_screen.dart)

---

## 5. Components and patterns

- **Buttons**: Primary = `FilledButton`; secondary/cancel = `OutlinedButton`. Use theme `colorScheme.primary` and `outline`.
- **Lists**: `ListTile` for alarms and laps; `Divider` between items; no cards unless doc is updated.
- **Inputs**: `TextField` with label/hint; `SwitchListTile` for toggles.
- **Empty states**: Centered text (bodyLarge) + one `FilledButton` or `FilledButton.icon`.

---

## 6. Motion and feedback

- **Transitions**: Default route transition (e.g. push Settings).
- **Feedback**: Ripple on tap (theme `splashFactory`). Optional later: subtle pulse on alarm ring.

---

## 7. How to use this document to update the UI

- **Changing a color or type style**: Update the token in section 2, then change the corresponding value in `lib/shared/theme/` (app_colors.dart, app_typography.dart, or app_theme.dart).
- **Changing a screen layout**: Update the screen subsection in section 4, then edit the listed implementation file.
- **Adding a component pattern**: Add it to section 5; if a new shared widget is created, add its path and mention in [NOTATION.md](NOTATION.md) if it becomes a convention.
- **After implementing**: Update this doc so it stays the single source of truth.
