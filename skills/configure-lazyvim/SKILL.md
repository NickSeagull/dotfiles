---
name: configure-lazyvim
description: Maintain this dotfiles repository's Home Manager-managed LazyVim configuration and Neovim dependencies.
---

The user chose Homebrew for Neovim: declare it in `homebrew.brews` in
`hosts/corthan/darwin.nix`. Avoid also installing it through Home Manager's
`programs.neovim`. Homebrew installs its dependencies, including tree-sitter.
Home Manager owns `nvim/init.lua` and recursively links `config/nvim/lua/`,
all with `force = true`, so this repository stays the source of truth.

For installation or theme changes, apply
[configure-app-theme](../configure-app-theme/SKILL.md): Cyberdream default dark
with scarlet `#FF493D` and upstream cyan `#5EF1FF`.
The plugin and LazyVim colorscheme override live in `lua/plugins/theme.lua`;
the bootstrap's install colorscheme must also prefer Cyberdream. Scarlet UI
highlights and lualine's normal mode accent preserve upstream syntax colors.
After activation, install the newly declared plugin and apply the theme to
existing Neovim servers through RPC, preserving buffers and sessions.

The user prefers long lines to wrap instead of scrolling horizontally. Keep
`wrap` and `linebreak` enabled in `config/nvim/lua/config/options.lua` so lines
wrap visually at word boundaries without changing the file's contents.

lazy.nvim manages downloaded plugins in Neovim's data directory. Its mutable
lockfile belongs in `stdpath("state")`, not beside the Nix-owned config files.
Preserve this separation when changing the bootstrap. Set `vim.g.mapleader`
and `vim.g.maplocalleader` at the start of `config/lazy.lua`, before loading
lazy.nvim; keep LazyVim's space and backslash defaults.

Use Home Manager program modules for additional Nix-managed supporting tools
when available. Node.js is in `home.packages` for Mason's npm-based tools.

Herdr's Neovim integration is `ChmaraX/herdr-nvim`, declared in
`config/nvim/lua/plugins/herdr.lua` with `opts = { keymaps = false }` and
explicit lazy.nvim-managed annotation keymaps under `<leader>a`. Keep
`lazy = false` so `:Herdr` is available immediately even with `keys`.
Herdr's sidebar daemon calls `require("herdr-nvim").setup()` again on `VimEnter`;
plugin-owned maps then warn about every existing mapping. Keep keymap ownership
in lazy.nvim so repeated setup stays quiet. Keep separate normal and visual
callbacks for comments and references so character selections retain columns.
Reproduce sidebar startup in checks by registering its second setup with a
pre-init `--cmd` VimEnter autocmd; a plain headless launch misses the bug.
Home Manager force-links
`config/herdr/config.toml` and `config/herdr-nvim/config.toml` into their XDG
config directories. Keep Herdr's mutable plugins, sessions, sockets, and logs
outside the repository. The Herdr plugin itself is already installed.

The user prefers direct `cmd+e` / `cmd+o` for the sidebar/file picker; retain
`prefix+e` / `prefix+o` as fallbacks. Herdr's built-in `edit_scrollback` and
`open_notification_target` default to those prefix bindings and take priority
over plugin commands, so move them to `prefix+shift+e` / `prefix+shift+o`.
Pico appearing on `prefix+e` means scrollback editing won, not that Neovim failed.
The sidebar explicitly uses `/opt/homebrew/bin/nvim`. Home Manager also
force-links `config/ghostty/config.ghostty` at Ghostty's native macOS config
path to free Cmd+E/O for Herdr. Reload Ghostty after changing its keybindings.
Validate with `HERDR_CONFIG_PATH="$PWD/config/herdr/config.toml" herdr config check`
and `ghostty +validate-config`, then reload Herdr with `herdr server reload-config`.

Verify the `:Herdr` command and annotation keymaps after
installing with `:Lazy install`. Existing persistent Herdr Neovim daemons
keep their loaded configuration until restarted; save buffers before restarting.
Upstream setup: https://github.com/ChmaraX/herdr-nvim#install.

Build the combined system with `darwin-rebuild build --flake '.#corthan'`, then
use [activate-darwin](../activate-darwin/SKILL.md) for the user's preferred native
macOS authorization dialog. Verify with `nvim` and `:LazyHealth` after activation.
