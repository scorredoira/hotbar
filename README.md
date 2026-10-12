# Hotbar

Menu bar app with three actions:

- **Cycle Windows** (F15): brings the next visible window of the frontmost app to the front.
- **Turn Off Screen** (F18): `pmset displaysleepnow`.
- **Sleep** (F19): `pmset sleepnow`.

F14 is swallowed so it no longer dims the screen.

Install with `./install.sh`. It starts at login. Cycling windows needs Accessibility permission (System Settings → Privacy & Security → Accessibility).
