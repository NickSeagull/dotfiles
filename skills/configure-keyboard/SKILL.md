---
name: configure-keyboard
description: Plan or configure held-letter action layers in these dotfiles, preserving the agreed platform scope, typing behavior and Nix ownership.
---

# Keyboard action layers

The user wants Nikita Voloboev-style **held-letter action layers**: hold an
ordinary letter to select a set of actions, then press another key to select an
action. See `GLOSSARY.md`. Do not interpret this request as arbitrary simultaneous
multi-letter chords or a sequential leader-key workflow.

Confirmed scope for this effort:

1. Implement on macOS first, keeping layer definitions portable to Linux and
   Windows later. Later-platform deployment is not part of the first version.
2. Cover app launching/focusing, text navigation and window management. Exact
   trigger letters, actions, timing and exceptions still require decisions.
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
records supersede the initial pending choices above. Finish the map with a
verified standalone execution task;
do not deploy a remapper merely to finish charting the map.

Verify the repository-pinned package, matching macOS virtual driver, available
modules, permissions and service integration against primary sources. Treat
documented platform support separately from a working deployment on this Mac.
In particular, verify how a system-level keyboard service invokes actions in
the signed-in user's session rather than assuming GUI actions work as root.

Test proposed letter-layer behavior against ordinary fast typing and intentional
actions. Simple tap/hold support does not establish exact Goku simlayer behavior.
Agree emergency stop/recovery behavior before activation, preserve unsaved work,
and respect cancellation of the native authorization dialog.

Keep local research under Git-ignored `.agents-state/docs/`. Publish durable
findings and citations in the relevant research ticket resolution. Review every
tracked change for sensitive information before the authorized commit and push.
