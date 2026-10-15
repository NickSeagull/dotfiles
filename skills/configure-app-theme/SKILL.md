---
name: configure-app-theme
description: Apply Nick's Cyberdream dark theme with scarlet accents when installing apps or configuring application themes in these nix-darwin/Home Manager dotfiles.
---

Treat theme configuration as part of installing a themeable app. The standing
preference is Cyberdream default dark with scarlet accents; no further palette
decision is needed. An explicit theme choice in the current request takes
precedence. Apply this to the app being installed or configured; a single-app
request does not authorize retheming every installed app.

## Palette

Use Cyberdream's default dark palette, with only its red overridden to
`#FF493D`. Preserve the remaining upstream colors and their semantic roles.

| Role | Color |
| --- | --- |
| Background | `#16181A` |
| Alternate surface | `#1E2124` |
| Highlight surface | `#3C4048` |
| Foreground | `#FFFFFF` |
| Primary accent / red | `#FF493D` |
| Secondary accent / cyan | `#5EF1FF` |

Use scarlet for configurable interface accents such as focus borders and active
controls, with cyan secondary. Keep ordinary text readable and preserve distinct
syntax, success, warning, error, and diff colors. The rejected muted palettes
and the earlier teal `#2DD4BF` concept are not this choice. Prefer dark mode over
automatic light/dark switching unless explicitly requested otherwise.

The accepted decision is recorded in the
[desktop planning map](https://plane.p.egregore.io/egregore/projects/e4709aa7-c911-4a7b-a9ec-f9eaa2bb905b/issues/7d839361-92ca-440f-b7b0-1e85f9b38167/).
The palette above makes routine installs independent of tracker access.

## Apply the theme

1. Inspect the app's existing configuration and current official theme docs.
   Check its native theme, custom palette, and accent support. Prefer the
   [official Cyberdream plugin or app export](https://github.com/scottmckendry/cyberdream.nvim#-extras)
   with a small scarlet override. Inspect its actual colors; a similarly named
   theme does not establish that it matches this palette.
2. Prefer the pinned Home Manager program module for supported settings. For
   external config files or theme assets, keep their source in this repository
   and link them through `home.file` or `xdg.configFile` with `force = true`.
   Follow existing application ownership choices, including Homebrew apps.
   Pin fetched theme assets through Nix rather than downloading into live config
   during activation. Keep mutable app state outside Nix-owned files.
3. If there is no official port but custom colors are supported, adapt the
   upstream palette to documented app roles. If only a named Cyberdream theme is
   available, select it and report any unsupported scarlet override. If neither
   a suitable theme nor custom colors are supported, finish installation and
   explain the limitation. Do not silently substitute another theme or replace
   the requested app.
4. Validate the app's config using its available checker and build the affected
   Darwin configuration with `darwin-rebuild build --flake '.#corthan'`. Check
   the selected theme and accent after automatically activating the successful
   build with [activate-darwin](../activate-darwin/SKILL.md), as authorized by
   this repository's `AGENTS.md`. Reload affected apps safely and preserve
   unsaved work. Report what actually activated and any runtime limitation.

Herdr uses `config/herdr/config.toml`: `name = "terminal"` plus a full
`[theme.custom]` Cyberdream palette, because there is no built-in Cyberdream.
Keep `accent` and `red` scarlet, `teal` upstream cyan, and `auto_switch = false`.
LazyVim uses `config/nvim/lua/plugins/theme.lua` to install Cyberdream, select it
through LazyVim's `colorscheme` option, and apply the red override plus scarlet
interface highlights. Keep lazy.nvim's install colorscheme aligned in
`config/nvim/lua/config/lazy.lua`. Theme changes in existing Neovim servers
should be applied through RPC without discarding buffers or restarting sessions.

Codex CLI uses the pinned official TextMate export in `config/codex/default.nix`,
with the red override and the filename `cyberdream-scarlet.tmTheme`. Home Manager
force-links it under `~/.codex/themes/` and reapplies `tui.theme` on activation.
Its config also stores mutable trust/plugin/onboarding state: keep that file
writable and use the TOML-preserving activation helper for the owned theme key.
Do not migrate the standalone Codex installation or overwrite unrelated config.
The CLI theme colors code blocks and diffs; it does not recolor the full TUI.
Already-running CLI sessions can select the installed theme with `/theme`;
preserve active work instead of restarting them.

Wallpaper concepts live in `assets/wallpapers/cyberdream-scarlet/`, with their
generation prompts alongside the PNGs. The connected Samsung LC34G55T ultrawide
was verified at 3440 × 1440 on 2026-10-15; recheck connected displays before
future exports. Keep scarlet dominant and cyan restrained, with dark breathing
room behind windows. Nick selected **Cinder Horizon** as the persistent wallpaper.
`config/wallpaper.nix` force-links it at
`~/Pictures/Wallpapers/cinder-horizon.png` and uses `programs.desktoppr` with
`scale = "fill"` and `setOnlyOnce = false`. Its activation waits for the image
link, and the `org.nix-community.home.wallpaper` LaunchAgent reapplies it at
login. Use the module's `desktoppr` binary to verify the current image. Keep
future wallpaper changes tied to an explicit selection or request.
The initial concepts were generated at 1935 × 812, then upscaled and slightly
cropped to the monitor's exact dimensions; do not call them native-resolution
generations.

There is no universal macOS application-theme switch. If this flake later adopts
[Stylix](https://nix-community.github.io/stylix/), reuse its shared palette and
supported targets, adding app-specific overrides where needed. Do not add a
theming framework solely to install one app. Check target coverage and actual
colors rather than assuming a shared setting themes every application.
