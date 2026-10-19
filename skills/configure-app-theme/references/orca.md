# Orca appearance

Orca is installed through nix-darwin's `homebrew.casks` as
`stablyai/orca/orca`, with the `stablyai/orca` tap. The pinned Home Manager
has no Orca module; nixpkgs' `orca` is the GNOME screen reader.
The official cask installs `/Applications/Orca.app` and its bundled `orca` CLI.

`config/orca/default.nix` force-links the owned palette under
`~/.config/orca/theme.json` and reconciles only the appearance keys during Home
Manager activation. The terminal uses Cyberdream dark with scarlet ANSI red;
the surrounding interface uses Orca's native dark theme. Orca 1.4.230 does not
expose a full interface palette or global accent setting in its settings schema.
Do not claim the entire application has a custom Cyberdream theme.

Orca stores mutable data under `~/Library/Application Support/orca` (lowercase).
Before first launch, the helper seeds `orca-data.json` for Orca's own import.
Existing profiles use `profiles/*/profile-state.db`. The helper supports schema
3, validates the settings hash, backs up locally, and updates only the settings
domain with its hash, timestamp and global/domain revisions. It leaves legacy
JSON exports unchanged after SQLite takes ownership. Never link profile state
to the Nix store or commit it: it can contain credentials and repository paths.

No write occurs when the owned keys already match. If settings must change,
Orca must be closed; preserve active sessions and unsaved work. Future database
schemas fail explicitly and require checking upstream before updating the helper.
Do not reset profiles or use recovery rollback just to change a theme.

Verify the active system, `/Applications/Orca.app`, `orca --version`, and the
settings domain's owned keys after activation and first launch. Recheck the
schema whenever upgrading Orca.

Sources: [installation](https://www.onorca.dev/docs/install),
[settings](https://www.onorca.dev/docs/settings),
[settings types](https://github.com/stablyai/orca/blob/v1.4.229/src/shared/global-settings-types.ts),
[state schema](https://github.com/stablyai/orca/blob/v1.4.229/src/main/persistence/profile-state/profile-state-database-schema.ts),
[domain writes](https://github.com/stablyai/orca/blob/v1.4.229/src/main/persistence/profile-state/profile-state-documents.ts).
