# Hotbar

Menu bar app with four actions:

- **Cycle Windows** (F15): brings the next visible window of the frontmost app to the front.
- **Turn Off Screen** (⌃⌘B): `pmset displaysleepnow`.
- **Sleep** (F19): `pmset sleepnow`.
- **Restart Handy** (⌃⌘H): kills Handy (it sometimes hangs) and opens it again.

F14 is remapped to F20 (with `hidutil`, on every keyboard as it connects) so it no longer dims the screen.

Install with `./install.sh`. It starts at login. Cycling windows needs Accessibility permission (System Settings → Privacy & Security → Accessibility).
