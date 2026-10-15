---
name: activate-darwin
description: Build and activate this Mac's nix-darwin and integrated Home Manager configuration using the native macOS administrator password dialog.
---

Use this for authorized installations and configuration activations in this
dotfiles repository. The user prefers entering their password in the system
authorization dialog so the agent can finish activation itself.

Build and inspect the change before requesting elevated execution. From the
repository, build with `darwin-rebuild build --flake '.#corthan'`. Nix flakes
ignore untracked files: include newly referenced configuration files in Git's
view (intent-to-add is sufficient) before building. Preserve unrelated changes.

Tell the user the system authorization dialog is about to appear, then run:

```sh
/usr/bin/osascript /absolute/path/to/skills/activate-darwin/scripts/activate.applescript /nix/store/BUILT-SYSTEM
```

Resolve the script relative to this skill, including when Home Manager links it
under `~/.codex/skills/activate-darwin`. Resolve the successful build's `result`
symlink and pass that exact `/nix/store/` system path as one argument. The script
updates the system profile with `nix-env --set`, then runs that build's
`sw/bin/darwin-rebuild activate`, matching the activation part of `switch`.
Build as the regular user: rebuilding a user-owned Git worktree as root fails
libgit2's ownership check. Do not change Git's safe-directory settings to bypass it.
Run and compile AppleScript using the tool's elevated execution permission when
required by the sandbox; without scripting-addition access, compilation may
misreport `do shell script` as a syntax error. Native authorization does not
replace tool permission.

Use `do shell script ... with administrator privileges` for native authorization.
Do not collect passwords in chat, custom dialogs, variables, environment values,
arguments, files, or logs. Do not add `sudo` or change sudoers for this workflow.
The dialog may be skipped when macOS has cached authorization.

Treat cancellation (AppleScript error -128) as cancellation: stop activation
and do not reopen the dialog automatically. Diagnose command failures before
retrying. Verify `/run/current-system` and the requested application after a
successful switch; report only what actually activated.

Reference: [Apple Technical Note TN2065](https://developer.apple.com/library/archive/technotes/tn2065/_index.html).
