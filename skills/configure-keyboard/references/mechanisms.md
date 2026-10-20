# Mechanisms and ownership

Read this when changing how input reaches actions, how services interact, or how
disable survives restarts. Paths are relative to the working dotfiles repository.

## Source map

| Source | Owns |
| --- | --- |
| `config/keyboard/layout.json` | Portable hold threshold, modifier/trigger pairs, movement intents, named actions |
| `config/keyboard/macos.json` | Native navigation shortcuts and application bundle identifiers |
| `config/keyboard/generate.py` | Kanata source/base layers, tap/hold decisions, shortcut bypass, release cleanup |
| `config/keyboard/packages.nix` | Pinned Kanata overrides: restricted TCP commands and upstream simulator |
| `config/keyboard/service.py` | Root supervisor, authenticated control socket, engine process, persistent state, health checks |
| `config/keyboard/runner.py` | User-session control connection, notification decoding, native helper lifetime, failure reporting |
| `config/keyboard/actions.m` | Cocoa launch/focus and Accessibility app/window snapshots |
| `config/keyboard/default.nix` | Packages, validation, commands, driver installation, launchd jobs, forced Home Manager links |

`hosts/corthan/darwin.nix` imports the keyboard module. Home Manager forces
`~/.config/keyboard`, `~/.local/bin/keyboard`, and this skill. Generated config is
an output, not an editing surface. The privileged engine reads its immutable
store config, not a user-editable replacement under the home directory.

## Input decisions

`generate.py` emits `tap-hold-tap-keys` with a zero tap-repress window and the agreed
hold timeout. A listed interrupting key selects ordinary typing before timeout;
that press cannot later turn into a hold. Zero repress prevents a quick second
press from bypassing a deliberate hold. `concurrent-tap-hold` preserves each key's
own timing. Modifier holds exclude other home-row modifier keys from their
interrupt lists so simultaneous holds can mature independently; action-layer
triggers retain the full interrupt list. The list comes from `KEYS`: adding a physical key requires
checking both processing and interruption coverage, not only an active-layer map.

A `fork` around home-row modifier keys bypasses their held role only when a
physical modifier is down. Physical modifiers emit their normal output plus
distinct `nop0`–`nop7` markers, which produce no OS key events. Synthetic home-row
modifiers emit no markers and therefore allow other modifier holds to stack.
Distinct markers keep the bypass active when one of several physical modifiers
is released. Layer triggers retain their output-modifier `fork`, so modified
shortcuts never enter action layers.

Keep `fork` directly around `tap-hold-tap-keys`: wrapping it in `switch` prevented
the pinned Kanata's concurrent hold handling from resolving simultaneous modifier
holds independently and delayed the 200 ms boundary in simulator traces.

Held layers map action keys directly, so `z+j` moves down and `b+n` focuses Notion
instead of invoking base modifier/trigger roles. `deflayermap` ends with `___ XX`:
unassigned inputs are inert, including processed keys outside `defsrc`.

Navigation/selection triggers combine `layer-while-held` with an `on-release`
virtual cleanup action. Cleanup releases arrow and modifier outputs even when an
action key is still held. Merely popping the layer would leave its output active
until that action key released. Text actions emit native key chords and repeat;
`push-msg` app/window actions fire on a physical press rather than on repeat.

The accepted bindings and native word-motion limitation are in
[the contract](bindings.md). Tap/hold support is not a claim of exact Goku simlayer
behavior or zero accidental activation during slow typing overlaps.

## Process and message flow

The canonical architecture decision is [Choose the remapper and action dispatch
boundary](https://plane.p.egregore.io/egregore/projects/e4709aa7-c911-4a7b-a9ec-f9eaa2bb905b/issues/24b27577-47e5-4139-a52f-03ab90385012/).

```text
physical HID → Kanata (root) → virtual driver → native text shortcuts
                   │
              TCP notifications
                   ↓
            supervisor (root)
                   │
       authenticated Unix socket
                   ↓
        runner (console user) → native helper (same user) → GUI apps/windows
```

The supervisor selects a loopback TCP port and starts Kanata with `--port`,
`--cfg`, and `--no-wait`. It consumes newline-delimited `LayerChange` and
`MessagePush` JSON and forwards events to the registered runner. The engine patch
in `packages.nix` rejects incoming commands except `Hello`; local TCP clients must
not reload config, activate fake keys, or change layers in a privileged process.
The supported `push-msg` notification format remains intact.

The root Unix socket is `/var/run/org.nick.keyboard.sock`, mode 0600, owned by the
configured user. `getpeereid` authenticates the kernel-reported peer UID. CLI
requests use `{"command":"status"}`, `enable`, `disable`, or `permissions`.
The runner registers with `{"command":"register","accessibility":true}`.
Supervisor envelopes include `event`, `ping`, and permission requests; runner
replies include `ack`, current `accessibility`, or `failure`.

The runner refreshes Accessibility on pings and dispatches allowlisted semantic
actions. A window-layer `LayerChange` starts/ends the native snapshot. The helper
uses newline JSON over stdin/stdout. Its call timeout is 3.5 seconds; supervisor
health checks stop capture after four seconds without acknowledgement. Revisit
both budgets when changing action execution. Do not block them on cold app startup.

`actions.m` submits new launches to LaunchServices without waiting for the full
startup. Existing apps are activated, never hidden or quit. Window-layer entry
snapshots app order and per-app Accessibility windows; next/previous actions move
indices within those snapshots. Recomputing MRU order after every focus change
would toggle the last two apps. Telegram's observed bundle is
`com.tdesktop.Telegram`; resolve installed bundle IDs instead of assuming variants.

## State and service lifetime

| State | Meaning |
| --- | --- |
| `disabled.json` under `/var/db/org.nick.keyboard/` | Durable reason/time; only explicit enable clears it |
| `active` under the same directory | Capture journal; leftover at supervisor startup latches disable |
| In-memory runner/TCP connections | Current health, not permission to clear the disable latch |

The directory is root-owned mode 0700; disable files are mode 0600 and atomically
replaced after flushing. Neither state nor logs belong in the repo or Nix store.
Failure records disable before stopping the engine and issuing one notification
per transition into disabled state. Every unexpected exit counts, including
Kanata 1.11's successful raw emergency exit. TCP layer switching is not cleanup.

All three jobs use `KeepAlive = false`:

| launchd target | Role |
| --- | --- |
| `system/org.nick.keyboard` | Supervisor and its root Kanata child |
| `system/org.nick.keyboard-driver` | Signed virtual-HID daemon |
| `gui/$(id -u)/org.nick.keyboard-actions` | Runner and native helper |

Orderly supervisor termination stops capture and clears its active journal,
preserving enabled startup. Runner loss while the configured user owns
`/dev/console` disables remapping; loss after console-user change is treated as a
session transition. These branches are implementation logic, not proof that an
actual logout/login was tested. EOF, reset and a failed notification write must
all drop the runner without destroying the supervisor's status/control socket.

## Driver and permissions

At the implementation checkpoint the pinned packages were Kanata 1.11.0 and its
`darwinDriver` 6.2.0. The signed extension reports its own version 1.8.0, not the
package's version. Re-evaluate the lock/package on upgrades; these are different
version namespaces. No suitable dedicated module was found at that pin, so the
module uses generic Darwin launchd and Home Manager facilities.

macOS registration needs the real signed manager application under
`/Applications/.Karabiner-VirtualHIDDevice-Manager.app`; a symlink resolving into
the store does not provide that installation. Activation copies the package with
`ditto`, preserves signed contents, and keeps its source receipt outside the bundle
at `/var/db/org.nick.keyboard-driver-source`. Existing unmanaged managers are
preserved. The daemon executable comes from the matching Nix package.

Extension approval, executable Input Monitoring where required, and the user
helper's Accessibility grant are separate from a successful Nix build. A helper
launched from an already-authorized agent can report trusted while the same
helper in its LaunchAgent is untrusted. Use live `keyboard status` for that grant.
Avoid rebuilding/changing helper identity unnecessarily during unrelated edits.
