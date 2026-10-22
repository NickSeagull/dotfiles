---
name: configure-keyboard
description: Adjust or troubleshoot this dotfiles repo's Kanata keyboard layers, home-row modifiers, app/window actions, persistent disable, services, and macOS permissions. Keep the keyboard-reference skill synchronized when these controls change. Also use when planning changes to the accepted keyboard contract.
---

# Keyboard action layers

This Mac uses mirrored held-key layers: hold an ordinary typing key, then press an
action with the opposite hand. Kanata owns input interpretation and native text
shortcuts; a user-session runner owns app/window actions. Nix manages both, with
forced Home Manager links. The vocabulary is in the repository's `GLOSSARY.md`.

## Load the relevant reference

| Work | Read |
| --- | --- |
| Show the user's keyboard/chord reference | [Keyboard reference skill](../keyboard-reference/SKILL.md) |
| Bindings, timing, selection, hand rules, or scope | [Accepted contract](references/bindings.md) |
| Generator, transport, action runner, services, state, or driver changes | [Mechanisms and ownership](references/mechanisms.md) |
| Status, recovery, permissions, safe adjustment, or tests | [Operations and verification](references/operations.md) |
| Avoiding implementation-session mistakes; previous evidence and limits | [Session learnings](references/session-learnings.md) |

Reference paths such as `config/keyboard/` are relative to the working dotfiles
repository. The skill may be installed under `~/.codex/skills/configure-keyboard`;
that installation is a managed copy/link, not the repository to edit. Keep durable
operational documentation here in `references/`, never in the runtime folder.

## Maintain the user-facing reference

The user's "keyboard" scope is home-row modifiers, text navigation/selection,
app/window layers, and disable/recovery. App-specific shortcuts belong in other
references unless explicitly requested.

Whenever an implemented change affects those controls, update
`skills/keyboard-reference/references/keyboard.md` in the same change, alongside
the accepted contract and relevant operations/mechanism documentation here.
Check the reference against `config/keyboard/layout.json`, `macos.json`, the
generator's timing/precedence behavior, and `service.py`'s recovery commands.
Keep opposite-hand examples, mirrored triggers, action names, timing, and recovery
accurate. If the scope or presentation rules change, update the companion
`SKILL.md` too. Planning alone must not present proposed bindings as deployed.

Edit repository sources rather than installed skill links. Both skills are
Home Manager-managed; build/activate their updates with the existing activation
skill and verify the installed reference matches the repository.

## Essential constraints

1. Preserve deliberate 125 ms holds, permanent cancellation by an early action keypress,
   ordinary modified shortcuts, mapped-action precedence, and immediate cleanup on
   trigger release. Home-row modifiers may stack, including on the same hand;
   each needs its own 125 ms hold. Layer actions use one key per hand and
   selection emits Shift internally. Physical modifiers bypass held roles.
2. Keep the engine/runner boundary: root Kanata emits supported `push-msg`
   notifications; only the signed-in user's runner performs GUI actions. Keep
   portable definitions separate from macOS shortcuts and bundle identifiers.
3. Emergency recovery is physical Left Control+Space+Escape. Engine/runner failure
   restores ordinary input and persistently disables remapping until explicit
   re-enable. Keep recovery keyboard-only; do not add mouse/menu controls or a
   custom GUI. Preserve state outside the repo/Nix store; never defeat disable with
   startup cleanup, unconditional KeepAlive, or a restart loop.
4. Use the existing [activation skill](../activate-darwin/SKILL.md) for authorized
   build and activation. Record the initial enabled/disabled state, preserve
   unsaved work, and leave an intentional disable intact. OS permissions are real
   prerequisites; they do not require asking for activation permission again.
5. Run meaningful agent checks for the changed mechanism. The user declined
   mandatory hardware checks and user-run sign-off. Report untested physical/HID
   coverage honestly; simulation does not establish physical capture or emergency
   chord execution. Do not force a reboot/logout for evidence.

Use Kanata with its matching signed Karabiner virtual driver, not Karabiner's
mapping engine or Goku. The deployed target is macOS; Linux/Windows deployment is
out of scope. Preserve Raycast on Command+Space, Ghostty/Herdr Command+E/Command+O,
and the separate Moom/manual-placement preference. No automatic tiling, Mission
Control bindings, arbitrary simultaneous-letter chords, or sequential leader
workflow is part of the accepted starter scope. The user can explicitly amend it.

When invoked through Wayfinder, distinguish planning from authorized execution.
The [planning map](https://plane.p.egregore.io/egregore/projects/e4709aa7-c911-4a7b-a9ec-f9eaa2bb905b/issues/d4071ffd-1238-4f47-bc7d-f573f2260f7e/)
indexes the canonical decisions; the linked implementation task was completed.
Do not deploy a remapper merely to finish a planning map. For a new adjustment,
start with current source and state rather than reconstructing the old session.
