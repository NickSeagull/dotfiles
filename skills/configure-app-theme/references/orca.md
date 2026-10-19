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

## Agent integration preference

Nick wants Orca agent guidance available across projects, preferably supplied
by Orca itself, otherwise as global skills. Do not copy Orca skills into each
project. Keep any persistent installation managed through Home Manager.

Verified with Orca 1.4.230: `orca skills install --all` installs globally by
default and targets detected agents plus the shared skills directory. Use
`--agent universal` for only `~/.agents/skills`. The installed skills are small
discovery stubs; `orca skills get <topic>` serves the version-matched guide from
the executable. `orca skills update --all` refreshes stubs to the installed build.
No general automatic skill-injection switch was established by this investigation.

For supervised delegation, load `orca skills get orchestration` and use its
Run/Task/Dispatch lifecycle with `orca orchestration worker-start`. Provider
subagent tools do not establish Orca orchestration provenance. Ordinary agent
launches and ownership handoffs use `orca agent launch` or
`orca worktree create --agent`; browser and terminal controls use `orca-cli`.
Skills teach the CLI workflow; they do not register an MCP server or configure
credentials for unrelated tools. Recheck these contracts after Orca upgrades.

Sources: [installation](https://www.onorca.dev/docs/install),
[settings](https://www.onorca.dev/docs/settings),
[settings types](https://github.com/stablyai/orca/blob/v1.4.229/src/shared/global-settings-types.ts),
[state schema](https://github.com/stablyai/orca/blob/v1.4.229/src/main/persistence/profile-state/profile-state-database-schema.ts),
[domain writes](https://github.com/stablyai/orca/blob/v1.4.229/src/main/persistence/profile-state/profile-state-documents.ts),
[global skill installation](https://github.com/stablyai/orca/blob/b2879bd5aaac5d27c101ccf4171faa25d9f0bb1e/src/cli/specs/skills.ts),
[orchestration discovery stub](https://github.com/stablyai/orca/blob/b2879bd5aaac5d27c101ccf4171faa25d9f0bb1e/skills/orchestration/SKILL.md).
