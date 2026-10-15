# Manage LazyVim in these dotfiles

**Use Home Manager for Neovim and external tools, repo Lua for configuration, and lazy.nvim for plugins. Keep both `lazy-lock.json` and `lazyvim.json` writable. Automatic update checking does not install updates.**

Research completed 2026-10-15 for [Verify LazyVim integration and automatic update mechanisms](https://plane.p.egregore.io/egregore/projects/e4709aa7-c911-4a7b-a9ec-f9eaa2bb905b/issues/115e1ae1-e058-4e1e-91b8-3e59401d32bf/), a child of [Define a LazyVim management skill for these dotfiles](https://plane.p.egregore.io/egregore/projects/e4709aa7-c911-4a7b-a9ec-f9eaa2bb905b/issues/1fa08275-767b-46c6-a808-a6b2b08a3bb9/). This report resolves technical facts, not Nick's update cadence, unattended scope, or failure policy. The intended skill is `.agents/skills/lazyvim/SKILL.md`; implementation and installation have not started.

## Observed starting point

| Item | Evidence |
| --- | --- |
| Repository baseline | `6534e8be84ba0391c58f29d8f3875b1e89ef824f`, `https://github.com/NickSeagull/dotfiles` |
| Platform/integration | `aarch64-darwin`, `darwinConfigurations.corthan`; `flake.nix` imports `home-manager.darwinModules.home-manager`; user `nick` imports `hosts/corthan/home.nix` |
| Existing configuration | Home module has no Neovim configuration, no user packages, and no managed home files. `home.stateVersion` is `26.05`; preserve it. |
| Read-only personal-path inspection | `~/.config/nvim` absent; `~/.local/share/nvim` exists and is empty; `~/.local/state/nvim` contains `nvim.log`, `shada`, `swap`; `~/.cache/nvim` absent. `command -v nvim` resolves `/opt/homebrew/bin/nvim`. These are observations, not permission to delete or replace state. |
| Evaluated pin | `programs.neovim.enable` is `false`; pinned `pkgs.neovim.version` is `0.12.4`; the Home Manager Neovim package's Lua is `luajit-2.1.1774638290`. Evaluation succeeded after allowing Nix its cache lock. No build or editor runtime was run. |

Repository facts are available in the [baseline flake](https://github.com/NickSeagull/dotfiles/blob/6534e8be84ba0391c58f29d8f3875b1e89ef824f/flake.nix), [lock](https://github.com/NickSeagull/dotfiles/blob/6534e8be84ba0391c58f29d8f3875b1e89ef824f/flake.lock), [home module](https://github.com/NickSeagull/dotfiles/blob/6534e8be84ba0391c58f29d8f3875b1e89ef824f/hosts/corthan/home.nix), and [Darwin module](https://github.com/NickSeagull/dotfiles/blob/6534e8be84ba0391c58f29d8f3875b1e89ef824f/hosts/corthan/darwin.nix). Personal paths and local command results are dated observations, not independently published evidence.

### Source revisions

| Source | Revision inspected |
| --- | --- |
| Home Manager | `db7d5e2332710f5abb088f6b5de927d7f9511b35` from `flake.lock` |
| nixpkgs / nix-darwin | `55afc4c3adc7194df3b96d43b7d18bf8131bfcfa` / `c3e90c89649b07d1a96e4b9dd6cd0d6e44b91a74` from `flake.lock` |
| LazyVim starter | `803bc181d7c0d6d5eeba9274d9be49b287294d99`, official HEAD resolved with `git ls-remote` |
| LazyVim | `999700997f72227187d49d8b92667183dc7fc809`, official HEAD resolved with `git ls-remote` |
| lazy.nvim | `306a05526ada86a7b30af95c5cc81ffba93fef97`, official HEAD resolved with `git ls-remote` |

Upstream web documentation and Mason READMEs were checked on the report date. They can change; recheck requirements before installation or upgrades. HEAD inspection does not mean the starter's `stable` bootstrap branch is at the inspected lazy.nvim HEAD.

## Requirements and package ownership

The current [LazyVim requirements](https://www.lazyvim.org/) specify Neovim at least `0.11.2` with LuaJIT, Git at least `2.19`, tree-sitter CLI and a C compiler for Treesitter, and curl for completion downloads. Nerd Font v3+, lazygit, and fzf integration are optional; fd/ripgrep support file search and live grep. The pinned Neovim evaluation satisfies the stated Neovim minimum; actual native-plugin and terminal behavior still needs validation.

The pinned [Home Manager Neovim module](https://github.com/nix-community/home-manager/blob/db7d5e2332710f5abb088f6b5de927d7f9511b35/modules/programs/neovim/default.nix) provides `programs.neovim.enable`, a `package` defaulting to `neovim-unwrapped`, and a wrapped `finalPackage`. Enable this module instead of duplicating Neovim in `home.packages`. Leave its plugin list empty when lazy.nvim owns plugins. Its generated `nvim/init.lua` is conditional on nonempty `initLua`; leave `initLua` and `extraConfig` empty when repo files own startup. Do not add a competing generated startup file. Alias/default-editor settings remain separate choices.

The same module's `extraPackages` adds executable directories to the **suffix** of Neovim's PATH. Therefore a preexisting earlier binary may still win. Use Home Manager program modules for tools where those modules exist at the pin; otherwise use pinned packages. Inspect the actual Neovim PATH and `vim.fn.exepath()` before claiming a tool comes from Nix. Provider flags such as `withNodeJs` are not a replacement for explicitly provisioning language runtimes required by servers or plugins. With state version `26.05`, Python provider defaults differ from earlier compatibility defaults; enable providers only for a demonstrated dependency. [Pinned module](https://github.com/nix-community/home-manager/blob/db7d5e2332710f5abb088f6b5de927d7f9511b35/modules/programs/neovim/default.nix).

### Mason and external language tools

[Mason](https://github.com/mason-org/mason.nvim) installs language servers, formatters, linters, and debuggers beneath Neovim data, and normally prepends its bin directory to PATH. Its packages are independent of Nix generations and `lazy-lock.json`. Some need npm, cargo, archive tools, or other runtimes. macOS support does not make every individual package available for Apple Silicon.

Current [LazyVim LSP source](https://github.com/LazyVim/LazyVim/blob/999700997f72227187d49d8b92667183dc7fc809/lua/lazyvim/plugins/lsp/init.lua) uses Mason by default for supported configured servers and installs missing `stylua` and `shfmt` through its Mason configuration. Its `mason = false` server option enables use of an externally installed server. If the agreed boundary means **all** external tools belong to Home Manager, the implementation must also prevent default Mason tool installation, including extra-specific lists. An `opts` function can replace an inherited list; merely adding an empty list may merge rather than clear it. Disabling the Mason and mason-lspconfig plugins is another possible integration, but must be checked against every enabled extra. Do not call one boundary enforced until the resolved specs and executable paths prove it.

`MasonUpdate` refreshes registries; it does not upgrade all installed tools. Mason's package update UI and registry refresh are separate from lazy.nvim plugin updates. Keep any future Mason exception explicit so the same tool is not silently managed twice. [Mason commands and configuration](https://github.com/mason-org/mason.nvim), [LazyVim LSP integration](https://github.com/LazyVim/LazyVim/blob/999700997f72227187d49d8b92667183dc7fc809/lua/lazyvim/plugins/lsp/init.lua).

## Bootstrap, configuration, plugins, and extras

1. Inspect actual XDG paths and existing files before migration. Preserve existing configuration and user state with a uniquely named backup; do not mechanically run the destructive removal commands in the generic installation example. Upstream recommends backing up configuration and optionally data/state/cache. [Installation](https://www.lazyvim.org/installation).
2. Obtain the official starter in a temporary checkout and copy the reviewed configuration files into the chosen repo source directory. Keep this repository's Git metadata. The [starter bootstrap](https://github.com/LazyVim/starter/blob/803bc181d7c0d6d5eeba9274d9be49b287294d99/lua/config/lazy.lua) clones lazy.nvim's `stable` branch into `stdpath("data")/lazy/lazy.nvim` if missing, prepends it to runtimepath, imports LazyVim plugins, then imports repo plugin specs. First run requires network and writable data.
3. Keep general settings in `lua/config/options.lua`, `keymaps.lua`, and `autocmds.lua`; keep plugin specifications in `lua/plugins/*.lua`. The starter's `init.lua` loads `config.lazy`; LazyVim handles the other config modules at their proper lifecycle stages. [Configuration](https://www.lazyvim.org/configuration).
4. Add/override plugins with Lua specs; prefer `opts` and `opts` functions, disable a plugin with `enabled = false`, and use `pin`, `commit`, `tag`, or `version` for a deliberate exception. User specs merge with upstream defaults; inspect the resolved spec rather than editing downloaded plugin files. [Plugin customization](https://www.lazyvim.org/configuration/plugins), [spec fields](https://lazy.folke.io/spec).
5. Use `:LazyExtras` or explicit extra imports for supported bundles. An extra can add tools, parsers, and plugin build requirements; inspect its current source before enabling it. `:LazyExtras` persists selection and requests restart. [Extras](https://www.lazyvim.org/extras), [extras implementation](https://github.com/LazyVim/LazyVim/blob/999700997f72227187d49d8b92667183dc7fc809/lua/lazyvim/util/extras.lua).

Treesitter parsers are additional mutable compiled assets, not simply Git plugins. Current [LazyVim Treesitter source](https://github.com/LazyVim/LazyVim/blob/999700997f72227187d49d8b92667183dc7fc809/lua/lazyvim/plugins/treesitter.lua) installs missing parsers and runs parser updates as a plugin build action. It conditionally pins the Treesitter plugin below Neovim 0.12. Thus an unattended plugin update can invoke builds and parser updates; a narrow description of “only pull Lua files” would be incorrect.

## Writable files with Home Manager

| File/directory | Owner and write requirement |
| --- | --- |
| Neovim executable and external tools | Nix store/Home Manager generation; immutable |
| Repo Lua | User's checked-out dotfiles; deployed as reviewed files or links |
| `lazy-lock.json` | lazy.nvim writes installed Git revisions; default location is `stdpath("config")/lazy-lock.json` |
| `lazyvim.json` | LazyVim persists extras and migration metadata; default is configuration root, overridable through `vim.g.lazyvim_json` |
| Plugins, parser binaries, cache, logs/state | Writable standard data/cache/state directories; retain outside the Nix store |

[lazy.nvim defaults](https://lazy.folke.io/configuration) and [lock writer](https://github.com/folke/lazy.nvim/blob/306a05526ada86a7b30af95c5cc81ffba93fef97/lua/lazy/manage/lock.lua) show that updates open the lockfile for writing and create its parent directory. [LazyVim config](https://github.com/LazyVim/LazyVim/blob/999700997f72227187d49d8b92667183dc7fc809/lua/lazyvim/config/init.lua) and [JSON writer](https://github.com/LazyVim/LazyVim/blob/999700997f72227187d49d8b92667183dc7fc809/lua/lazyvim/util/json.lua) establish the second writable file. The latter silently skips saving if opening fails, so seeing an extras toggle once is insufficient proof it persisted.

**Inference from these writers and Home Manager's linking implementation:** linking the entire configuration directory to a normal Nix-store `source` makes the default runtime writes fail. Recursively linking files does not make an already linked `lazy-lock.json` writable. Viable designs are:

1. Home Manager links configuration to a stable, writable checkout using `config.lib.file.mkOutOfStoreSymlink` with a deliberate absolute **string** path. Do not pass a relative flake path and assume it still refers to the original checkout: flake evaluation uses copied store sources. Avoid activating links to this temporary research worktree. Such a link means Git edits are live and generation rollback does not roll them back.
2. Home Manager links only immutable Lua/startup files into a mutable configuration root, while runtime JSON remains unowned ordinary writable files. The skill then needs an explicit rule for copying/versioning checkpoints or configuring the writable lockfile location. Do not put those runtime files back under ordinary store links.

Both mechanisms need actual activation/write validation before installation is considered complete. The research does not select one. lazy.nvim explicitly supports overriding `lockfile` with a writable path outside the config root; its writer creates the configured parent directory. This permits immutable Lua plus a runtime lock under state/data, but keeping a separate reviewed repository snapshot requires an explicit synchronization/checkpoint procedure. Redirecting LazyVim JSON likewise preserves writeability but changes where extras are recorded. [Pinned Home Manager file logic](https://github.com/nix-community/home-manager/blob/db7d5e2332710f5abb088f6b5de927d7f9511b35/modules/files.nix), [recursive option](https://github.com/nix-community/home-manager/blob/db7d5e2332710f5abb088f6b5de927d7f9511b35/modules/lib/file-type.nix).

## Real automatic updates

**The starter checks automatically but does not apply updates.** It enables lazy.nvim's checker and suppresses update notifications. The checker calls fetch/check operations; actual plugin checkout/build and lockfile changes belong to `update`. Missing-plugin installation at startup is also distinct from updating installed plugins. [Starter](https://github.com/LazyVim/starter/blob/803bc181d7c0d6d5eeba9274d9be49b287294d99/lua/config/lazy.lua), [checker](https://github.com/folke/lazy.nvim/blob/306a05526ada86a7b30af95c5cc81ffba93fef97/lua/lazy/manage/checker.lua), [manager operations](https://github.com/folke/lazy.nvim/blob/306a05526ada86a7b30af95c5cc81ffba93fef97/lua/lazy/manage/init.lua).

| Mechanism | What it actually does | Remaining policy |
| --- | --- | --- |
| Checker | Fetches/checks and optionally notifies while Neovim runs | Useful status only; insufficient for requested automatic application |
| Startup/event Lua hook invoking `require("lazy").update({ wait = true, show = false })` | Applies plugin changes during an editor session | Cadence, startup delay, concurrent sessions, reload/restart behavior |
| Scheduled headless invocation | Runs the same updater without an interactive editor | Cadence, logged-in session, PATH/environment, contention, logs and failure handling |
| Flake input update plus Darwin rebuild | Updates Nix-managed Neovim/tools through a new generation | Separate authorization and cadence; lazy.nvim cannot update Nix packages |

The documented synchronous CLI form uses a bang: `nvim --headless '+Lazy! update' +qa`; `sync` also installs and cleans, so it has a broader mutation scope. Commands/APIs update the lockfile. No built-in automatic-application option was found in the inspected lazy.nvim configuration: the policy and trigger require repo integration. [Usage](https://lazy.folke.io/usage), [command implementation](https://github.com/folke/lazy.nvim/blob/306a05526ada86a7b30af95c5cc81ffba93fef97/lua/lazy/view/commands.lua).

The pin supports `launchd.agents.<name>.enable` and `.config` with `ProgramArguments`, `StartInterval` or `StartCalendarInterval`, environment, and output/error paths. This supplies an existing Home Manager mechanism for a scheduled updater; there is no need to guess a Linux service on macOS. Use the pinned absolute Neovim/tool paths and explicit environment, because LaunchAgents do not inherit an interactive shell's setup. Availability does not choose Nick's cadence or approve unattended Nix activation. [LaunchAgent module](https://github.com/nix-community/home-manager/blob/db7d5e2332710f5abb088f6b5de927d7f9511b35/modules/launchd/default.nix), [job options](https://github.com/nix-community/home-manager/blob/db7d5e2332710f5abb088f6b5de927d7f9511b35/modules/launchd/launchd.nix).

### Failure evidence and rollback

The inspected manager can update some plugins while others fail, and its post-operation callback writes a lockfile reflecting installed revisions. The runner stops the failed plugin's pipeline, not all pipelines; task errors are stored and printed in headless mode. Its code does not establish that a final `+qa` will return nonzero for each plugin task failure. **Inference:** do not treat exit zero or a changed lockfile alone as successful unattended updating. Validate a wrapper that detects plugin task failures, captures logs, applies a timeout, and serializes conflicting update/restore writers. Internal error APIs are version-sensitive; any implementation using them must pin/recheck and exercise the failure path in isolation. [Manager](https://github.com/folke/lazy.nvim/blob/306a05526ada86a7b30af95c5cc81ffba93fef97/lua/lazy/manage/init.lua), [runner](https://github.com/folke/lazy.nvim/blob/306a05526ada86a7b30af95c5cc81ffba93fef97/lua/lazy/manage/runner.lua), [tasks](https://github.com/folke/lazy.nvim/blob/306a05526ada86a7b30af95c5cc81ffba93fef97/lua/lazy/manage/task/init.lua).

A rollback checkpoint must preserve a known-good lockfile **before** updating, plus matching Lua and extras state. Version control of `lazy-lock.json` is upstream's recommendation, compatible with automatic updates but requiring a separate decision about when/how changes become commits. To recover plugins, restore the saved config/lockfile, run `:Lazy restore` (or its waited headless form), restart, and verify features. An older plugin tree can require its matching older configuration and metadata schema; restoring only plugin commits after a configuration migration can still fail. Native plugin outputs and parser binaries may need rebuilding with compatible tools. Pin an offending plugin while investigating if necessary. Restoring the lockfile alone does not change already checked-out plugins, and rollback is not a transaction spanning parsers, downloaded binaries, and Mason packages. [Lockfile](https://lazy.folke.io/usage/lockfile), [version fields](https://lazy.folke.io/spec/versioning).

For Nix-managed executables, the installed `darwin-rebuild --help` confirms `build`, `switch`, `--rollback`, and `--switch-generation`. A generation rollback does not restore mutable plugin data, writable configuration, or external Mason installations. Keep those recovery procedures separate. Exact local build command: `darwin-rebuild build --flake '.#corthan'`; activation command: `sudo darwin-rebuild switch --flake '.#corthan'`. These commands were identified from integration/help, not executed.

## Validation and skill acceptance requirements

1. **Before writing:** re-read this checkout's pins/modules and actual paths; locate the stable checkout and all writable state. Record executable versions, resolved Nix package, and ownership. Preserve user work and migration backups. Follow the existing `home-manager-install-program` and `home-manager-options` skills.
2. **Build without activation:** evaluate options and run the Darwin build for approved Nix changes. Ensure the intended new files are visible to the Git-backed flake. Report build failures before attempting a switch; do not edit `home.stateVersion` as a repair.
3. **Isolate runtime checks:** use a temporary root for `XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `XDG_STATE_HOME`, and `XDG_CACHE_HOME`, plus a distinct `NVIM_APPNAME`; copy the proposed config there. Confirm `stdpath()` outputs before bootstrap. `-u` alone selects an init file without isolating data/state, and `--clean` bypasses the setup being validated. [Neovim v0.12.4 standard paths and arguments](https://github.com/neovim/neovim/blob/v0.12.4/runtime/doc/starting.txt).
4. **Demonstrate lifecycle behavior:** bootstrap from empty isolated data; validate lockfile and extras persistence; inspect resolved specs and `exepath()` for Nix tools; run `:LazyHealth` and relevant targeted checks; open representative files to exercise completion, LSP, formatting, and parser features. Check output and optional-provider warnings against enabled features rather than claiming every optional dependency is mandatory. `:LazyHealth` loads all plugins then invokes `checkhealth`. [Installation guidance](https://www.lazyvim.org/installation), [command implementation](https://github.com/LazyVim/LazyVim/blob/999700997f72227187d49d8b92667183dc7fc809/lua/lazyvim/config/init.lua).
5. **Demonstrate updates/recovery:** prove the chosen trigger applies a revision change, honors its cadence/scope, preserves a prior checkpoint, prevents overlap, reports a forced failure correctly, and restores a known-good lock. After authorized activation, check real deployed paths and persistence. Leave a concise report identifying exact files, checks, runtime limits, and the recovery command. Do not report live installation success from isolated checks alone.

These are acceptance requirements for later implementation, not tests performed in this research. This research used read-only repo/personal-path inspection, pinned-source review, online primary docs, option/version evaluation, and help output. It installed nothing, launched no Neovim runtime, built no configuration, activated nothing, and changed no personal editor state.

## Decisions still requiring Nick

1. Choose automatic-update trigger/cadence and define whether it may run during active editor sessions.
2. Specify unattended scope: plugins and their build/parser effects; whether Nix-managed tool upgrades or any Mason exception is included.
3. Select failure behavior and checkpoint retention, including whether/how changed lockfiles become Git history.
4. Choose the configuration deployment mechanism and stable checkout contract if using a writable out-of-store link.

Next action: resolve those questions in the map's HITL decision; use this report as evidence for the standalone skill implementation task.
