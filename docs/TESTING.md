# Testing

E2E test cases and retest plan. Retest per this document after UI or feature changes. Scope and behavior are defined in [FEATURES.md](FEATURES.md) and [SCOPE.md](SCOPE.md).

---

## 1. Test scope

- **Platforms**: Web, Android, iOS. Sound and scheduled notifications are **mobile-only**; on web, timer/alarm persistence and UI work, but no ringtone and no scheduled notifications.
- **Features under test**: Clock, Timer, Alarm, Stopwatch, Timer history, Stopwatch previous runs, Settings.

---

## 2. E2E test cases by feature

### Clock

| Case | Steps | Expected |
|------|--------|----------|
| Time updates | Open app, stay on Clock tab | Time updates every second; date correct |
| No crash | Open app | Clock tab loads without error |

### Timer

| Case | Steps | Expected |
|------|--------|----------|
| Set and start | Set duration (e.g. 1 min), tap Start | Countdown updates every second |
| Pause / resume | Start timer, tap Pause; tap Resume | Time pauses then resumes |
| Reset | Start timer, tap Cancel | Timer clears; picker shown |
| Complete (mobile) | Start short timer, wait for 0 | Notification appears; sound plays until Dismiss |
| Complete (web) | Start short timer, wait for 0 | "Timer done" + Dismiss button; no sound |
| History (after feature) | Complete or cancel a timer | Entry appears in History section; persists after restart |

### Alarm

| Case | Steps | Expected |
|------|--------|----------|
| Add alarm | Tap Add/FAB, set time/label, Save | Alarm appears in list |
| Edit alarm | Tap alarm, change time/label, Save | List updates |
| Delete alarm | Tap alarm, Delete, confirm | Alarm removed |
| Toggle | Toggle switch on list item | Enabled state changes; (mobile) scheduling updates |
| Empty state | Delete all alarms | "No alarms" + Add alarm button |
| Web | Add/edit/delete alarm | All succeed; no throw (scheduling is no-op on web) |

### Stopwatch

| Case | Steps | Expected |
|------|--------|----------|
| Start / lap | Start, tap Lap several times | Elapsed updates; laps listed |
| Pause / resume | Start, Pause, Resume | Time pauses then resumes |
| Reset | Run then Reset | Time and laps clear |
| Persistence | Start, close app, reopen | Elapsed and laps restored if run was active |
| Previous runs (after feature) | Run, Lap, Reset | Run appears in Previous runs; persists |

### Settings

| Case | Steps | Expected |
|------|--------|----------|
| Open | Tap app bar settings icon | Settings screen opens |
| Theme list | View Settings | Theme and About rows visible; Theme subtitle shows current mode |
| Theme picker | Tap Theme, choose Light/Dark/System | Bottom sheet; selection applies; back to Settings |
| About | Tap About | About dialog with app name and version |
| Back | Tap back / system back | Returns to main app; theme applied if changed |

---

## 3. Platform matrix

| Area | Web | Android / iOS |
|------|-----|----------------|
| Timer completion sound | No sound | Sound + notification until Dismiss |
| Alarm scheduling | No-op (no notification at time) | Scheduled notification + ringtone at time |
| Alarm CRUD and list | Yes | Yes |
| Theme persistence | Yes | Yes |
| Timer / stopwatch persistence | Yes | Yes |
| Settings screen | Must open and work | Must open and work |

---

## 4. Retest plan

- **When**: After any change to timer, alarm, stopwatch, settings, notifications, or theme; before marking a release.
- **What**: Run through E2E cases for the changed feature(s); smoke test all tabs and Settings on at least one platform (e.g. web).
- **Checklist** (quick pass):
  - [ ] Clock: time updates
  - [ ] Timer: start, complete, dismiss; (web) no throw
  - [ ] Alarm: add, edit, delete; (web) no throw
  - [ ] Settings: open, change theme, back
  - [ ] Stopwatch: start, lap, reset; (after feature) previous runs visible
  - [ ] Timer history (after feature): entry after complete/reset, persists
