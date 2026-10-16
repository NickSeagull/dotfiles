---
name: configure-keyboard
description: Plan or configure mirrored held-key action layers and home-row modifiers, preserving typing behavior, one key per hand and Nix ownership.
---

# Keyboard action layers

The user wants **held-key action layers** inspired by Nikita Voloboev: hold an
ordinary typing key to select a set of actions, then press a key with the other
hand to select an action. Mirrored triggers include punctuation. See
`GLOSSARY.md`. Do not interpret this request as arbitrary simultaneous multi-letter
chords or a sequential leader-key workflow.

Confirmed scope for this effort:

1. Implement on macOS first, keeping layer definitions portable to Linux and
   Windows later. Later-platform deployment is not part of the first version.
2. Cover category-based app launching/focusing, Vim-inspired native text movement
   and selection, window navigation, and mirrored home-row modifiers. The starter
   contract and recovery policy below are agreed.
3. Use Kanata as the mapping engine, with a small action runner in the signed-in
   user's session. Karabiner's macOS input driver is acceptable; Karabiner's
   mapping engine and Goku are not the chosen mapping stack.
4. Preserve the existing desktop effort's provisional Moom manual placement/drop
   zones, no automatic tiling, and keyboard window switching/navigation unless
   the user explicitly changes those choices. Raycast is the existing launcher
   and window-action baseline.
5. Manage configuration through Nix and forced Home Manager links. Implementation
   includes build, activation through `skills/activate-darwin/SKILL.md`, and
   verification of running behavior under the standing authorization in
   `AGENTS.md`.

Kanata owns letter layers, timing and navigation keystrokes. For app and window
actions, send named messages through Kanata's supported messaging interface to
the user-session runner. Keep the layer layout shared, with platform-specific
shortcuts and commands in adapters. Nix owns both Kanata and the runner. This
accepts one additional user-session service; exact action names, adapter details
and transport recovery remain implementation work to verify.

When invoked through Wayfinder, keep planning separate from installation. Read
the current decision records in [Plan portable held-letter action layers for this
Mac](https://plane.p.egregore.io/egregore/projects/e4709aa7-c911-4a7b-a9ec-f9eaa2bb905b/issues/d4071ffd-1238-4f47-bc7d-f573f2260f7e/)
before changing the agreed architecture or selecting starter bindings. Those
records are canonical. Finish the map with a
verified standalone execution task;
do not deploy a remapper merely to finish charting the map.

## Accepted starter contract

The canonical decision is [Define held-letter behavior and the starter action
layers](https://plane.p.egregore.io/egregore/projects/e4709aa7-c911-4a7b-a9ec-f9eaa2bb905b/issues/ce516f80-0377-43e1-ba25-f5dd27575e81/).
Apply these requirements to this effort, not unrelated keyboard projects.

Use one key per hand: no starter action may require holding two keys with the
same hand. Choose the layer trigger opposite the action key. Do not stack
home-row modifiers or require Shift as a third physical key for selection.
Additional generic modifier-combination holds are deferred; a layer action may
emit a combined shortcut internally. Existing physical modifier keys remain
available.

Use deliberate 200 ms tap/hold behavior. Taps type their ordinary characters.
Another key before the threshold commits ordinary typing and cancels the hold
until the trigger is released; it must not activate later during that press.
Never activate a hold early merely because another key is pressed or released.
Releasing a trigger exits its layer or modifier role immediately. Holding a
trigger alone does not repeat its character. Test this behavior; rare trigger
letters and a timeout do not guarantee zero accidental activation during slow
overlapping typing.

Bindings are global, with no initial app-specific overrides. Preserve existing
modified typing and shortcuts, including Command+Space for Raycast and the
Ghostty/Herdr Command+E and Command+O behavior. Modified base-layer shortcuts must
not unexpectedly enter action layers. Bound layer actions take precedence over
base home-row modifier and trigger roles; do not nest layers. Unassigned keys
inside an active layer do nothing. Text movement/selection repeats while an
action key is held; app/window actions fire once per physical press.

### Home-row modifiers

| Modifier | Left hold | Right hold |
| --- | --- | --- |
| Shift | a | semicolon |
| Control | s | l |
| Option | d | k |
| Command | f | j |

### Mirrored action layers

| Layer | Left hold | Right hold |
| --- | --- | --- |
| Text navigation | z | slash |
| Window navigation | x | period |
| Common apps | c | comma |
| Messaging | v | m |
| Notes/reference | b | n |

Selection uses an additional mirrored g/h hold pair with the same movement keys
as navigation, but emits the selection variant of each action. Release the
trigger to stop extending selection; do not leave a selection mode or synthetic
modifier latched. For example, g+j selects down and h+w selects forward a word.

### Text actions

| Action keys | Movement |
| --- | --- |
| h / j / k / l | Left / down / up / right |
| b | Native backward-word movement |
| w / e | Aliases for native forward-word movement |
| 0 | Line start |
| 4 | Line end, using the dollar-sign position without physical Shift |

Use z+h/j/k/l and z+0 for right-hand actions; slash+w/b/e and slash+4 for
left-hand actions. Use g or h, respectively, for selection equivalents.
On macOS native backward/forward word shortcuts target word beginnings/ends;
the user accepted that w and e are aliases. Do not promise exact Vim w/b/e
semantics, a Vim command interpreter, editing operators or normal/insert modes.
Destination-app interpretation can differ; verify native behavior in runtime
tests instead of silently adding app-specific exceptions.

### App and window actions

Common apps: comma+b = Zen, comma+t = Ghostty, comma+e = VS Code.
Messaging: m+t = Telegram, m+e = Element.
Notes/reference: b+n = Notion, b+o = Obsidian.
Each action launches its target or focuses it if running. It must not hide or
quit an already focused app.

Windows: x+h = previous app, x+l = next app; x+j = next window within the
current app, x+k = previous window within it. Maintain a stable cycle order
during one layer hold so repeated presses advance through the list instead of
toggling two apps. Adapter mechanics remain implementation work to verify.
Mission Control and window placement actions are excluded from these layers;
Raycast stays on Command+Space. Preserve the separate Moom placement preference.

## Verification and delivery

The canonical recovery decision is [Agree activation recovery and verification
for action layers](https://plane.p.egregore.io/egregore/projects/e4709aa7-c911-4a7b-a9ec-f9eaa2bb905b/issues/083edfd9-5154-41dd-8141-fd4869bb1dee/).

Emergency recovery is keyboard-only. Use Kanata's raw physical Left
Control+Space+Escape exit, accepted as an emergency-only exception to one key per
hand. Do not add a mouse/menu control or require a custom GUI. If either the
engine or action runner fails, restore ordinary typing, notify once and leave
remapping disabled until explicitly re-enabled. Emergency/failure disable must
survive service restarts and login; provide managed keyboard-accessible status
and re-enable commands. Keep mutable disable state outside the repository and
Nix store, separate from the forced managed configuration.

Do not use unconditional launchd KeepAlive or a crash-restart loop that defeats
disable. Verify wrapper exit-status handling: Kanata 1.11's default macOS raw
emergency exit is successful, and merely restarting on nonzero exits would still
violate the accepted fail-off policy. A TCP ChangeLayer to a passthrough layer is
not an emergency reset: it does not clear currently held layers/key state.
Verify ordinary input, modifier release and pending-repeat cleanup on stopping.

Build and validate before cutover. Prepare emergency/failure handling before
enabling remapping. Use `skills/activate-darwin/SKILL.md` for the automatic build
and native authorization workflow; respect cancellation and preserve unsaved
work. Verify services, dispatch, input behavior and stop/re-enable recovery in
the running system. Do not force a reboot or logout to obtain evidence.

The user explicitly declined a two-minute hardware check and user-run testing.
All required checks are agent-run: offline input/timing traces, available native
runtime checks, actions, selection and repeat cleanup, service failures/restarts,
and safe wake/reconnection coverage where available. Report physical-key/HID or
other untested coverage honestly without making user testing a completion gate.
Do not claim a synthetic test proves physical input capture or raw-key emergency
handling. OS-required permission/driver approvals remain genuine operational
prerequisites; they are not invitations to ask for activation permission again.

Verify the repository-pinned package, matching macOS virtual driver, available
modules, permissions and service integration against primary sources. Treat
documented platform support separately from a working deployment on this Mac.
In particular, verify how a system-level keyboard service invokes actions in
the signed-in user's session rather than assuming GUI actions work as root.

Test held-key behavior against ordinary fast typing and intentional actions,
including punctuation, mirrored triggers, role collisions such as b+n and z+j,
selection release, repeated app/window presses and existing modified shortcuts.
Simple tap/hold support does not establish exact Goku simlayer behavior.
Apply the agreed emergency policy before activation, preserve unsaved work,
and respect cancellation of the native authorization dialog.

Keep local research under Git-ignored `.agents-state/docs/`. Publish durable
findings and citations in the relevant research ticket resolution. Review every
tracked change for sensitive information before the authorized commit and push.

## Implemented stack and operating commands

The macOS implementation lives in `config/keyboard/`; `default.nix` is imported by
`hosts/corthan/darwin.nix`. Read its README for service, permission and verification
details. Keep shared bindings in `layout.json` and platform details in `macos.json`.
Telegram's installed bundle is `com.tdesktop.Telegram`; do not assume the App Store
bundle identifier. App launch requests must not block runner health checks during
slow startup. Preserve the helper's executable identity when its source does not
need to change, because macOS permissions are granted to actual executables.

Use `keyboard status`, `keyboard disable`, `keyboard enable` and
`keyboard permissions`. Disable state and the crash journal are root-owned under
`/var/db/org.nick.keyboard`; authenticate the user control socket with Darwin peer
credentials. Never clear disable state during activation. Explicit enable can
restart the failed runner and requests native authorization if the supervisor
itself needs restarting. Distinguish status `starting` from `running`.

Root launchd labels are `org.nick.keyboard` and `org.nick.keyboard-driver`; the
user LaunchAgent is `org.nick.keyboard-actions`. All use `KeepAlive = false`.
A matching signed DriverKit manager is copied under `/Applications` for system
extension registration; retain its signature and keep the source receipt outside
the app bundle. Nix remains the source of that copied payload. Home Manager forces
the remaining managed files and this skill.

The pinned engine's TCP interface is patched to reject mutating commands while
retaining push-msg notifications. Use Kanata's actual upstream simulator for
timing, collision, repeat and release tests; lifecycle tests use real sockets and
child processes with a fake engine. Run those lifecycle tests as the console user,
outside a socket-restricting sandbox. A reset/closed runner connection must disable
capture while leaving the supervisor's status/control socket available. Do not
replace these checks with a hand-written timing model.
