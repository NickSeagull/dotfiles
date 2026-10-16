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
3. Prefer a portable mapping engine. Kanata is a candidate, not an accepted
   selection. A dependency on Karabiner's macOS input driver is acceptable;
   this does not select Karabiner's mapping engine or Goku.
4. Preserve the existing desktop effort's provisional Moom manual placement/drop
   zones, no automatic tiling, and keyboard window switching/navigation unless
   the user explicitly changes those choices. Raycast is the existing launcher
   and window-action baseline.
5. Manage configuration through Nix and forced Home Manager links. Implementation
   includes build, activation through `skills/activate-darwin/SKILL.md`, and
   verification of running behavior under the standing authorization in
   `AGENTS.md`.

When invoked through Wayfinder, keep planning separate from installation. Read
the current decision records in [Plan portable held-letter action layers for this
Mac](https://plane.p.egregore.io/egregore/projects/e4709aa7-c911-4a7b-a9ec-f9eaa2bb905b/issues/d4071ffd-1238-4f47-bc7d-f573f2260f7e/)
before choosing an engine, dispatch mechanism or starter bindings. Those records
supersede the initial pending choices above. Finish the map with a verified standalone execution task;
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
