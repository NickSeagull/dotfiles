# Operations and verification

Run repository commands from the working dotfiles root. Inspect current source
and status; the previous session's store paths and process IDs are not reusable.

## Status and recovery

The agreed policy is recorded in [Agree activation recovery and verification for
action layers](https://plane.p.egregore.io/egregore/projects/e4709aa7-c911-4a7b-a9ec-f9eaa2bb905b/issues/083edfd9-5154-41dd-8141-fd4869bb1dee/).

| Command | Behavior |
| --- | --- |
| `keyboard status` | Reports disable reason, engine PID, runner connection, Accessibility and state |
| `keyboard disable` | Stops capture and persistently disables layers |
| `keyboard enable` | Explicitly clears disable after prerequisites; restarts a missing runner and waits for engine startup |
| `keyboard permissions` | Requests the connected helper's native Accessibility prompt |
| Physical Left Control+Space+Escape | Exits Kanata before remapping; supervisor latches disable even for exit status 0 |

`starting` is not `running`. `waiting-for-runner` has no connected engine. A
`running` status establishes a live engine notification connection; also inspect
Kanata's driver/capture logs before claiming working input capture. A missing
control socket is not evidence that layers are disabled: inspect the job/process.

Never repair disable by deleting state files. `keyboard enable` is the explicit
recovery path. If the supervisor is unavailable, that command requests the native
administrator dialog to restart it; it then restarts a missing user runner and
checks driver/Accessibility prerequisites. Report an actual prerequisite failure
instead of bypassing macOS permissions. Keep a pre-existing intentional disable.

## Make an adjustment

1. Record `git status --short`, `keyboard status` and `readlink /run/current-system`.
   Preserve existing work, initial disable intent and the old system target.
2. Read [the contract](bindings.md), then edit the owning source from
   [the mechanism map](mechanisms.md). Adjust meaningful traces if behavior changes.
   Do not hand-edit generated config, launchd plists or managed home links.
3. Run the checks relevant to the changed mechanism below. Finish source edits and
   GUI action checks before native activation, so one final build can be applied.
4. Build/activate using `skills/activate-darwin/SKILL.md`, including Git visibility
   for new files and the exact resolved build result. Disable capture when needed
   for cutover and password entry; do not run focus-changing tests during the dialog.
5. Verify the activated target, forced links, driver, services and final status.
   If the task intentionally disabled a previously enabled setup for cutover,
   explicitly resume only after its checks pass and any observed failure is
   resolved. Preserve a disable that predates the task or remains unexplained.

Home Manager service reload can disconnect the runner and latch disable even
though Nix activation succeeded. Inspect the reason and service health; a successful
switch does not establish that remapping is enabled. Do not silently erase that
latch during startup. Documentation changes to this managed skill also require
activation to update the installed skill; they do not require destructive live
failure tests or cycling the user's apps again.

## Targeted diagnostics

```sh
keyboard status
launchctl print system/org.nick.keyboard
launchctl print system/org.nick.keyboard-driver
launchctl print "gui/$(id -u)/org.nick.keyboard-actions"
systemextensionsctl list
```

| Symptom | Inspect and correct |
| --- | --- |
| `accessibility: false` in live status | Run `keyboard permissions`; grant the requested helper in System Settings → Privacy & Security → Accessibility. Pings refresh the grant. A direct helper probe inherited from the agent is insufficient. |
| Driver unavailable | Check extension registration and matching package/daemon. If registration is missing, run the installed manager command below and complete its native OS approval. |
| Runner disconnected/hung | Inspect the user log and helper timeout. Fix the action/transport problem, then explicitly enable. Runner restart alone must leave persistent disable intact. |
| `starting` never becomes `running` | Inspect engine exits, capture/driver permissions and TCP startup. Do not add automatic restart as a workaround. |
| Wrong app/window action | Resolve the installed bundle, inspect the adapter and session snapshots. Preserve nonblocking launch, stable cycle order and user-session execution. |

Driver registration, when actually missing:

```sh
/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager activate
```

Logs are `/var/log/keyboard.log`, `/var/log/keyboard-driver.log`, and
`~/Library/Logs/keyboard-actions.log`. Scope reads to relevant events. Root-owned
logs/launchd operations and local sockets may require tool sandbox escalation;
that is separate from native administrator authorization.

For release validation, `plutil -lint` checks the installed
`/Library/LaunchDaemons/org.nick.keyboard.plist`,
`/Library/LaunchDaemons/org.nick.keyboard-driver.plist` and
`~/Library/LaunchAgents/org.nick.keyboard-actions.plist`.
`readlink ~/.config/keyboard` confirms a managed generation link. Compare the
current system target against the successful build, not a remembered store hash.

## Deterministic checks

The integrated Nix build validates generated Kanata config and runs
`test_keyboard.py`. For the full input/lifecycle suite, build the repository's
actual upstream simulator and use its returned path:

```sh
keyboard_simulator=$(nix build --impure --no-link --print-out-paths --expr '
  let flake = builtins.getFlake (toString ./.);
  in (import ./config/keyboard/packages.nix {
    pkgs = flake.darwinConfigurations.corthan.pkgs;
  }).simulator
')
PYTHONDONTWRITEBYTECODE=1 \
KANATA_SIMULATOR="$keyboard_simulator/bin/kanata_simulated_input" \
python3 -m unittest discover -s config/keyboard/tests -v
```

Run lifecycle tests as the signed-in console user with permission for Unix/TCP
sockets and child processes. They use a harmless fake input engine; no physical
input is captured. They cannot run as the Nix build account, and a socket sandbox
can cause `bind: Operation not permitted` without a product failure.

The simulator accepts a single `-s` file per invocation and prints emitted events.
Use temporary traces without `-o` unless its pinned output-file behavior has been
verified; the session observed output replacing the trace filename. The simulator
package logs `SIM_MESSAGE` to expose named-action dispatch while preserving the
same Kanata state machine. Do not substitute a hand-written timing model.

Regression areas: 125 ms boundaries; early cancellation that remains cancelled;
fast typing/punctuation; physical modifier shortcuts; simultaneous/staggered
home-row modifier stacks in either order with independent release; mirrored triggers; `z+j`
and `b+n` precedence; inert unassigned/extended keys; selection and repeat cleanup;
once-per-press actions; successful/unexpected engine exit; runner EOF/reset, hang,
and notification-write failure; disable persistence and explicit recovery.

The build-time `Dispatch` tests validate every configured named action against
Kanata's single-string array payload and reject malformed/unknown payloads.
`RunnerTransport` in `test_lifecycle.py` additionally runs production `runner.py`
over a real Unix socket with a fake native helper. It checks repeated Telegram
dispatch, window-session boundaries, pings, malformed payloads and helper failure
reporting. Run these with the full suite above; they require local sockets and
are intentionally outside the Nix build-account checks. Simulator `SIM_MESSAGE`
counts and direct helper calls alone do not establish runner protocol decoding.

## Native and live checks when the change needs them

Inspect the actual configured helper path rather than guessing a store path or
choosing the last glob match. Its newline-JSON commands include `permissions`,
`probe`, `resolve`, `launch`, `begin`, `end`, `app.next`/`app.previous`, and
`window.next`/`window.previous`. Resolve with `{"command":"resolve","bundle":"..."}`;
launch with `{"command":"launch","bundle":"..."}`. `begin`/`end` delimit the
stable cycle snapshot. Native scratch windows can be created with `scratch`;
terminate only that fixture helper to remove its windows. Preserve the original
foreground app and never type test content into user documents or messages.

For transport changes, a connection to the actual engine should receive an
initial `LayerChange`; `Hello` should receive `HelloOk`, and mutating requests
should remain ignored. TCP layer changes must never serve as emergency recovery.

For lifecycle changes, a scoped agent-run failure check can kill the known user
job with `launchctl kill SIGKILL "gui/$(id -u)/org.nick.keyboard-actions"`. Verify
Kanata stops and disable persists. Restarting that job with `launchctl kickstart`
must not re-enable capture. Explicitly recover after fixing/verifying the cause.
Do not run these disruptive checks for a prose-only adjustment.

State coverage honestly: traces prove state-machine behavior; native adapters
prove action behavior; driver connection logs prove a connection. None alone
proves end-to-end physical HID capture, held-key cleanup during a physical stop,
or the raw emergency chord. Do not infer sleep/wake, external reconnection or
logout/login coverage. The user declined mandatory hardware checks and user-run
sign-off; report limitations without adding those as completion gates.
