---
name: keyboard-reference
description: Show this Mac's configured keyboard reference for held-letter modifiers, text navigation and selection, app/window actions, and disable/recovery commands. Use for keyboard or chord cheat-sheet requests.
---

Read [the keyboard reference](references/keyboard.md) and return its bindings and
recovery commands directly in chat, using compact tables. The user's meaning of
"keyboard" covers these global Kanata controls. Omit Herdr, Neovim, terminal,
Raycast, and other app-specific shortcuts unless explicitly requested.

Explain hold-first timing once, distinguish movement from selection, and show
opposite-hand combinations. Include mirrored triggers and the physical emergency
stop. A reference request does not authorize changing or enabling remapping.

The reference is maintained by [configure-keyboard](../configure-keyboard/SKILL.md).
When source is available, check `config/keyboard/layout.json`, `macos.json`, and
the recovery commands in `service.py` for drift. Resolve source paths from the
working dotfiles repository, not this skill's installed directory. If only the
installed reference is available, present it as the configured reference without
claiming live verification. Run `keyboard status` only when current status is
useful; a running service alone does not prove physical input capture.
