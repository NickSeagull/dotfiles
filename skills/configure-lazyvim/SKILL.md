---
name: configure-lazyvim
description: Maintain this dotfiles repository's Home Manager-managed LazyVim configuration and Neovim dependencies.
---

The user chose Homebrew for Neovim: declare it in `homebrew.brews` in
`hosts/corthan/darwin.nix`. Avoid also installing it through Home Manager's
`programs.neovim`. Homebrew installs its dependencies, including tree-sitter.
Home Manager owns `nvim/init.lua` and recursively links `config/nvim/lua/`,
all with `force = true`, so this repository stays the source of truth.

lazy.nvim manages downloaded plugins in Neovim's data directory. Its mutable
lockfile belongs in `stdpath("state")`, not beside the Nix-owned config files.
Preserve this separation when changing the bootstrap.

Use Home Manager program modules for additional Nix-managed supporting tools
when available. Node.js is in `home.packages` for Mason's npm-based tools.

Build the combined system with `darwin-rebuild build --flake '.#corthan'`, then
use [activate-darwin](../activate-darwin/SKILL.md) for the user's preferred native
macOS authorization dialog. Verify with `nvim` and `:LazyHealth` after activation.
