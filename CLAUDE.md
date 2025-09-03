# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Multi-layered dotfiles repository managed by chezmoi, combining:
- Chezmoi templating for cross-platform configuration management
- Homebrew for macOS package management with auto-syncing
- Nix/Home Manager for declarative package configuration
- Neovim (LazyVim) and Doom Emacs editor configurations

## Key Architecture

### Chezmoi Structure
- **dot_** prefix: Files that become dotfiles (e.g., `dot_zshrc` → `~/.zshrc`)
- **exact_** prefix: Directories managed exactly as-is
- **run_once_** prefix: Scripts executed once on initial setup
- **Templates**: Go template syntax with `.chezmoi.os` conditions
- **Ignore rules**: `.chezmoiignore` conditionally excludes OS-specific configs
- **External repos**: `.chezmoiexternal.toml` manages external configurations

### Package Management Layers
1. **Homebrew**: Primary macOS packages with custom auto-sync wrapper in `dot_zshrc`
2. **Nix/Home Manager**: Declarative system in `flake.nix` and `nix/hm.nix`
3. **Mason (Neovim)**: LSP servers and development tools

### Editor Configurations
- **Neovim**: LazyVim-based setup in `exact_dot_config/exact_nvim/`
- **Doom Emacs**: Configuration in `doom/` directory (currently disabled in external config)

## Common Commands

### Chezmoi Operations
```bash
chezmoi apply                    # Apply changes from repository
chezmoi edit ~/.zshrc           # Edit file in source directory
chezmoi add ~/.newfile          # Add new file to management
chezmoi diff                    # Preview changes before applying
chezmoi update                  # Update from repository
chezmoi managed                 # List managed files
chezmoi verify                  # Verify configuration
```

### Package Management
```bash
# Homebrew (auto-updates dot_Brewfile)
brew install <package>          # Installs and updates Brewfile
brew remove <package>           # Removes and updates Brewfile

# Nix/Home Manager
./reload.sh                     # Rebuild home-manager and sync doom
home-manager switch --flake .#$(nix eval --impure --raw --expr 'builtins.currentSystem')
```

### Development Environment
```bash
# Node.js version management
fnm use                         # Auto-switches to project's Node version
fnm install <version>          # Install specific Node version

# Neovim with LazyVim
nvim                           # Opens with full LSP support
:Mason                         # Manage LSP servers and tools
:Lazy                          # Plugin management

# Doom Emacs (when enabled)
doom sync                      # Sync packages and configuration
```

## Language-Specific Setup

### F# Development
Requires fsautocomplete installation:
```bash
dotnet tool install -g fsautocomplete
fsautocomplete --version       # Verify installation
```

Features:
- FsAutoComplete LSP with .NET 9 support
- Ionide-vim integration for F# Interactive
- Fantomas formatting
- netcoredbg debugging
- Custom keybindings in `lua/plugins/fsharp.lua`

### Go Development
- gopls LSP server (auto-installed via Mason)
- golangci-lint integration
- Debugging support configured

### TypeScript/JavaScript
- Full LSP with tsserver
- ESLint/Prettier integration
- Auto Node version switching with fnm

## Installation

### Windows
```powershell
winget install Bitwarden.CLI
iex "&{$(irm 'https://get.chezmoi.io/ps1')} init --apply 'https://github.com/NickSeagull/dotfiles.git'"
```

### macOS/Linux
```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply NickSeagull/dotfiles
```

## Critical Paths

- **Shell environment**: `dot_zshrc`, `dot_zprofile`
- **Package definitions**: `dot_Brewfile` (auto-synced), `flake.nix`, `nix/hm.nix`
- **Neovim config**: `exact_dot_config/exact_nvim/` → `init.lua` → `lua/config/` → `lua/plugins/`
- **Environment variable**: `CHEZMOI_DIR=$HOME/.local/share/chezmoi`
- **Bitwarden integration**: Enabled for secrets management

## Implementation Details

- Custom `brew()` function wraps Homebrew to auto-update `dot_Brewfile` on install/remove
- Git autopush enabled in `chezmoi.toml` for automatic repository updates
- fnm configured with `--use-on-cd` for automatic Node version switching
- Neovim lazy.nvim bootstraps from stable branch if not present
- PATH includes: `/opt/homebrew/bin`, `.NET tools`, Python 3.9 user bin
- Mason auto-installs LSP servers on first Neovim launch for configured languages