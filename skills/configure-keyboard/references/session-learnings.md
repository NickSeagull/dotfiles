# Keyboard implementation learnings

Use these lessons when adjusting the deployed stack. They describe the completed
implementation session, not permanent assumptions about today's live processes.

## Reusable corrections

| Finding | Guidance for the next adjustment |
| --- | --- |
| A conventional delayed hold or early-hold variant is insufficient | Preserve `tap-hold-tap-keys`, its cancellation semantics and zero repress window; verify with upstream event traces. |
| The output-modifier bypass also blocked intentional home-row stacks | Use separate no-op markers for physical modifiers; exclude home-row modifier peers from modifier interruption lists. Preserve layer-trigger shortcut bypass. A `switch` wrapper hid pending holds from concurrent handling in the pinned simulator; direct `fork` passes simultaneous, staggered, release and boundary traces. |
| Popping a layer does not release an already-held action output | Keep trigger-release virtual cleanup; test trigger release before action release and subsequent repeat events. |
| A closed runner can fail on reads or during event forwarding | Route EOF, reset and failed writes through the same runner-drop path. Keep the supervisor/control socket alive, persist disable and stop capture. |
| One passing lifecycle run missed a timing race | After a lifecycle fix, repeat the focused suite when timing remains uncertain; stop broad retesting once the concern is resolved. |
| Startup, app identity and permission context differed from assumptions | Use nonblocking LaunchServices requests, observed bundle IDs, and live LaunchAgent permission status. Direct probes from an authorized agent can inherit different permission context. |

## Activation lessons

Finish all changes and checks before opening the administrator dialog. The session
activated intermediate revisions and had to request authorization again after
late fixes. App-focus tests also obscured an open dialog. Serialize those steps:
GUI verification, final build, one activation, then running-state checks.

Resolve the actual successful `result` link programmatically. A mistyped/invented
store target caused a preflight failure before any activation occurred. Do not
select binaries by store-directory glob order either. An open AppleScript process
is not completed activation; wait for success and verify `/run/current-system`.
See the activation skill's [authorization reference](../../activate-darwin/references/authorization.md).

Activation/reload preserved disable as designed. It also disconnected a runner
and latched a new disable. Record the pre-change state and verify the final state;
never equate successful Nix activation with enabled input capture. Keep ordinary
input available during password entry, and preserve unsaved work throughout.

## Evidence checkpoint

The implementation was published on 2026-10-16 in
[Implement mirrored keyboard layers with persistent fail-off recovery](https://github.com/NickSeagull/dotfiles/commit/0fe8ccd58f22cf55487b858ca046b64c2a71f1a4).
The [completed execution task](https://plane.p.egregore.io/egregore/projects/e4709aa7-c911-4a7b-a9ec-f9eaa2bb905b/issues/6de506d2-c38a-477d-bdf1-f8a7690ea6f7/)
holds the final report and coverage limits. That session verified:

1. Eighteen input/lifecycle tests and 25 repeated focused lifecycle cases.
2. Native launch/focus for all seven starter apps, stable app cycling, within-app
   window cycling, and scratch native text movement/selection checks.
3. Real runner failure stopping Kanata, persistent disable through runner restart
   and activation, and explicit enable restoring healthy operation.
4. Driver registration/version connection, live supervisor/runner health, managed
   files, and TCP notification/Hello behavior with mutating commands rejected.
5. Direct publication to clean `main` and working-branch heads after a sensitive
   material review, with local evidence under ignored `.agents-state/`.

Physical raw emergency-chord execution, full physical key-to-GUI dispatch,
physical held-key stop cleanup, sleep/wake, external-keyboard reconnection and an
actual logout/login were not exercised. Existing Command shortcuts were checked
in the simulator, not physically inside each destination app. Do not convert that
historical implementation report into current runtime proof.

Keep future durable learnings in these skill-local references; put transient
research under `.agents-state/docs/`. Production source and its tests stay in
`config/keyboard/`; do not recreate a parallel runbook there.
