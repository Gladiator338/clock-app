# Task list

Consolidated checklist for UI design, test cases, fixes, and open source assets. Mark items with `[x]` when done. Refer to [SCOPE.md](SCOPE.md), [FEATURES.md](FEATURES.md), and [DECISIONS.md](DECISIONS.md) when implementing.

---

## A. UI design

- [x] Create **docs/UI_DESIGN.md** with design principles, visual tokens, shell/navigation, screen layouts, components, and "how to use" instructions.
- [x] Add **UI_DESIGN.md** to the table in **docs/README.md**; note that UI changes should follow it.
- [ ] Optionally add **docs/UI_DESIGN.md** to **.cursor/rules/clock-app-docs.mdc** for UI/layout/theme changes.

---

## B. Test document and retest plan

- [x] Create **docs/TESTING.md** with test scope, E2E cases by feature, platform matrix, and retest plan/checklist.
- [x] Add **TESTING.md** to **docs/README.md**; note "Retest per TESTING.md after UI or feature changes."

---

## C. Fixes (web and behavior)

- [x] **Web – notifications**: In **lib/core/notifications/notification_service.dart**, guard `init()`, `showTimerEndNotification()`, `scheduleAlarm()`, `cancelAlarm()`, `cancelTimerNotification()` with `kIsWeb` (return immediately on web).
- [x] **Web – timer end**: In **lib/features/timer/timer_screen.dart**, call notification and ringtone only when `!kIsWeb` in `_onTimerEnd`.
- [x] **Web – settings**: Verify Settings opens on web; add try/catch around Navigator/ThemePreference if needed.
- [x] **docs/DECISIONS.md**: Update "Web" bullet for kIsWeb and alarm/timer persistence on web.

---

## D. Timer history (new feature)

- [x] Update **docs/SCOPE.md**, **docs/FEATURES.md**, **docs/DECISIONS.md** for timer history.
- [x] Implement model + persistence + "History" UI in Timer screen; append on timer end/reset.

---

## E. Stopwatch previous runs (new feature)

- [x] Update **docs/SCOPE.md**, **docs/FEATURES.md**, **docs/DECISIONS.md** for stopwatch history.
- [x] Implement model + persistence + "Previous runs" UI in Stopwatch screen; append on reset.

---

## F. Open source assets

- [ ] Select and add 1–2 open source alarm/timer sounds to **assets/sounds/**; document source and license.
- [ ] Optionally wire custom sounds in **lib/core/audio/**; keep fallback to system ringtone.
- [x] Create **docs/ASSETS.md** listing assets, source URL, and license; link from README.

---

## G. Retest and close-out

- [ ] Run E2E checklist from **docs/TESTING.md** on web (and optionally mobile); fix regressions.
- [x] Mark completed tasks in this file with `[x]`.
