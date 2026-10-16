# Keyboard layers on macOS

Hold a trigger for 200 ms, then press an action with the other hand. Release
returns to typing. The complete binding contract is in
[the keyboard skill](../../skills/configure-keyboard/SKILL.md).

## Control and recovery

1. `keyboard status` shows engine, runner, Accessibility and persistent disable state.
2. `keyboard disable` stops capture and persistently disables layers.
3. `keyboard enable` explicitly resumes layers. It restarts a failed user runner;
   recovering a stopped supervisor uses the native macOS administrator dialog.
4. `keyboard permissions` requests the action helper's native Accessibility prompt.
5. Physical **Left Control + Space + Escape** exits Kanata before remapping.
   The supervisor treats every unexpected exit, including status 0, as disable.

Disable state lives in root-owned `/var/db/org.nick.keyboard/disabled.json`.
It survives activation, service restart and login. An active journal detects a
supervisor crash. Routine startup never deletes disable state. An orderly
supervisor stop/logout preserves enabled startup. No job has unconditional
KeepAlive. A stalled runner disables capture after four seconds without a reply.

The control socket `/var/run/org.nick.keyboard.sock` is restricted to the managed
user and verifies kernel peer credentials. The root engine receives immutable
store configuration. Its loopback TCP interface retains supported `push-msg`
notifications and Hello, while a pinned source patch rejects mutating commands.
Only the user LaunchAgent runs GUI actions. A failure sends one native notification
per transition into disabled state; ordinary typing remains available.

## Managed files and services

`layout.json` contains portable bindings and semantic action names. `macos.json`
contains native shortcuts and bundle identifiers. `generate.py` builds Kanata
configuration. Active layers suppress all unassigned keys, including keys outside
`defsrc`. Trigger-release virtual actions release navigation and selection output
before the action key itself is released.

The root jobs are `system/org.nick.keyboard` and
`system/org.nick.keyboard-driver`; the user job is
`gui/$(id -u)/org.nick.keyboard-actions`. Home Manager forces
`~/.config/keyboard`, `~/.local/bin/keyboard` and the keyboard skill. The signed
DriverKit 6.2.0 manager is copied from the matching Nix package into
`/Applications/.Karabiner-VirtualHIDDevice-Manager.app`, because macOS extension
registration requires an application there. Its source receipt is outside the
bundle at `/var/db/org.nick.keyboard-driver-source`; signed contents are preserved.
Existing unmanaged managers are preserved.

After initial installation, the manager's `Contents/MacOS/Karabiner-VirtualHIDDevice-Manager activate`
requests driver registration. macOS approval and Accessibility are OS permissions;
configuration activation is already authorized. `keyboard enable` remains explicit
after either emergency or failure disable. Do not force a reboot or logout.

## Verification

The Nix build validates configuration and runs deterministic traces through the
upstream pinned Kanata simulator. `packages.nix` also defines that simulator for
local tests. Set `KANATA_SIMULATOR` to its `bin/kanata_simulated_input`, then run
`PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s config/keyboard/tests -v`.
Run lifecycle tests in the signed-in user session with local socket access; they
use a harmless fake engine and never capture input. Nix build checks use
`test_keyboard.py`; user-session lifecycle tests run separately.

Runtime logs are `/var/log/keyboard.log`, `/var/log/keyboard-driver.log`, and
`~/Library/Logs/keyboard-actions.log`. Keep runtime state and local test evidence
out of Git and the Nix store. Simulator tests establish input logic, not physical
HID capture or execution of the raw emergency chord. Do not infer sleep/wake,
external-keyboard reconnection or logout coverage from a successful service test.
