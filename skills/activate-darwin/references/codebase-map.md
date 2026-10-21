# Codebase map

Open the [configuration overview](codebase/overview.html) first, then the
[keyboard runtime](codebase/keyboard.html) for the input services. Both are
standalone Archify HTML with clickable source references pinned to the inspected
commit. They describe configured behavior; they are not live service monitors.

## Follow the configuration

1. `flake.nix` selects the Nix inputs and exports `darwinConfigurations.corthan`.
   `flake.lock` pins those inputs. The only declared host is Apple Silicon macOS.
2. `hosts/corthan/darwin.nix` owns system configuration, Homebrew declarations,
   keyboard services and Home Manager integration. Determinate owns Nix itself.
3. `hosts/corthan/home.nix` imports user modules, selects user packages and forces
   managed configuration/skill links. Application-specific sources live in `config/`.
4. `config/keyboard/default.nix` builds and checks the generated Kanata layout,
   installs root services and adds the user action runner through Home Manager.
   Root captures input; only the user-session helper performs GUI actions.
5. The activation skill builds a generation, activates its exact store path and
   verifies `/run/current-system`. Managed skill documentation also needs activation.

## Preserve ownership when editing

Keep immutable configuration in the repository. Keep authentication, caches and
session state outside the repository and Nix store. Codex/Orca theme hooks update
only owned preferences in otherwise mutable files; Orca defers changes while open.
LazyVim installs plugins at runtime and keeps its lockfile in Neovim state.

The keyboard map expands build inputs, capture, event relay, GUI execution and
persistent disable. Consult the [keyboard mechanism reference](../../configure-keyboard/references/mechanisms.md)
before changing these boundaries. Build-time simulations do not prove physical
HID capture or execution of the physical emergency chord.

## Refresh the maps

The editable sources are [overview.architecture.json](codebase/overview.architecture.json)
and [keyboard.architecture.json](codebase/keyboard.architecture.json). Follow the
installed Archify skill: inspect the affected source, pin a committed revision,
update source ranges and meaning, then finalize each candidate serially with
`--repo-root` and `--quality showcase`. Never cite working-tree edits as committed
evidence. Keep the published HTML beside these sources and link new maps here.

Put draft candidates, finalizer/browser receipts and screenshots under ignored
`.agents-state/docs/`. Archify also writes an adjacent `*.delivery.json` provenance
sidecar, ignored here because it contains local execution paths. Preserve that
sidecar locally for strict checks. A fresh checkout can regenerate it by finalizing
the editable source. For browser checks, if automatic detection misses an existing
Chrome/Chromium executable, set `ARCHIFY_CHROME` to its path rather than installing
another browser solely to validate documentation.

Keep durable explanations and mechanism notes under their owning skill's
`references/`, linked from its `SKILL.md`; do not copy them into runtime config.
