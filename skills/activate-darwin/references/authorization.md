# Native activation: exact target and dialog handling

Use this when a native authorization dialog is pending or when coordinating a
change that affects app focus, input capture, or managed skills.

## Sequence

1. Finish authorized edits, validations and focus-changing GUI checks first.
   Include newly referenced files in Git's view before the final Nix build.
2. Build as the regular user. Resolve that successful build's `result` link with
   `readlink result`; confirm its target has executable `activate` and
   `sw/bin/darwin-rebuild`. Never type or invent a store hash from memory.
3. Announce the native dialog and invoke this skill's existing
   `scripts/activate.applescript` with that exact resolved store target. Resolve
   the script from the skill directory, including its installed Home Manager form.
4. Await that process's completion before launching app-focus tests, enabling
   remapping, or starting another activation. Keep ordinary keyboard input
   available for password entry when a remapper is being adjusted.
5. On success, verify `/run/current-system` equals the intended target, then check
   managed settings and affected services. For keyboard work, successful activation
   may preserve/latch disable; consult the keyboard skill before explicit recovery.

A documentation-only change to a Home Manager-managed skill still needs activation
to update the installed skill. It does not justify replaying unrelated GUI or
failure tests. Batch validated edits to reduce repeated administrator dialogs;
never assume a later invocation will reuse cached authorization.

## Pending or failed invocation

A yielded tool session or running `osascript` process is not activation success.
Poll its existing tool session, using bounded waits and concise progress updates.
If the native dialog is obscured, inspect only whether the existing SecurityAgent
process/window is present. When necessary, bring that existing process forward:

```sh
osascript -e 'tell application "System Events" to set frontmost of process "SecurityAgent" to true'
```

Do not run that command when no such dialog exists. It changes focus; it must not
click controls, inspect password fields, capture passwords/screenshots, or create
another dialog. Tool sandbox escalation for AppleScript/native scripting remains
separate from macOS administrator authorization.

If preflight fails, inspect the resolved build target and command error before
retrying. A preflight error is different from a user cancellation. AppleScript
error -128 is cancellation: stop and do not reopen the dialog automatically.
Preserve the working system and unsaved work. Never bypass Git ownership checks
by rebuilding the user's worktree as root, and never collect credentials in chat,
arguments, environment variables, logs or files.
