---
name: activate-darwin
description: Build and activate this Mac's nix-darwin and integrated Home Manager configuration using the native macOS administrator password dialog.
---

Use this for authorized installations and configuration activations in this
dotfiles repository. The user prefers entering their password in the system
authorization dialog so the agent can finish activation itself.

`AGENTS.md` grants standing authorization to build and activate configuration
changes automatically. Complete activation and safe app reloads before calling
the task done; do not end by asking the user to rebuild or review an artifact.

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

For GUI apps, check compatibility against the running macOS before choosing a
package: the newest Homebrew cask can target a newer OS even when its declared
minimum allows installation. This Mac runs macOS 26; Bartender's vendor currently
recommends version 6 for it. `home.packages` overrides `pkgs.bartender` to 6.6.2
with a checksummed archive from `downloads.macbartender.com`; the locked package's
older `www.macbartender.com` URL returns 404. There is no Bartender Home Manager
program module. Its unfree
permission is scoped to Bartender in `hosts/corthan/darwin.nix`. Recheck these
facts when updating the flake or macOS. Home Manager copies apps into
`~/Applications/Home Manager Apps`; verify that location as well as system state.

CodexBar is declared in nix-darwin's `homebrew.casks`: the locked Home Manager
and nixpkgs do not supply a module or package. Verify `/Applications/CodexBar.app`
and the cask's `codexbar` CLI after activation. The user needs several distinct
ChatGPT subscription accounts. CodexBar's managed Codex accounts support that;
account authentication is completed in the app. Research notes belong under the
Git-ignored `.agents-state/docs/` directory, per `AGENTS.md`.

Codex shortcuts live in `config/codex/default.nix` as Home Manager-owned
executables under `~/.local/bin`, so they work without replacing shell startup
files. `cx` runs `codex --approve-for-me`; `cxh` uses the same flag with
`CODEX_HOME=~/.codex-h` and file credential storage. The alternate home shares
the default home's config, skills, and themes through managed links, while its
`auth.json` and session state stay separate. Use `cxh login` for the second
ChatGPT subscription; never copy credentials from the default home. Codex
`--profile` selects configuration overrides and does not provide a separate
login store. Verify both wrappers' argument forwarding and separate login
status after activation without logging out or interrupting active sessions.

CodexBar normally has no Dock icon or main window; a live process alone does not
prove its menu is accessible. If the icon is missing, quit and relaunch once,
waiting for the old process to exit before reopening (otherwise LaunchServices
can return -600). Bartender can verify and reveal the item without GUI scripting:

```sh
osascript -e 'tell application id "com.surteesstudios.Bartender" to list menu bar items'
osascript -e 'tell application id "com.surteesstudios.Bartender" to activate "com.steipete.codexbar-codexbar-codex"'
```

Use the ID returned by Bartender; the example is the separate Codex icon. Confirm
the menu appears. `NSStatusItem VisibleCC codexbar-merged = 0` is normal when
separate provider icons are in use; do not treat it alone as a visibility fault.
