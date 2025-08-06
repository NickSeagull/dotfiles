# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a chezmoi dotfiles repository that manages personal configuration files and system setup for macOS. The repository uses chezmoi templating to conditionally install configurations based on the operating system.

## Key Architecture

### Chezmoi Structure
- **dot_** prefix: Files that become dotfiles (e.g., `dot_zshrc` → `~/.zshrc`)
- **exact_** prefix: Directories that should be managed exactly as-is
- **Templates**: Files use Go templating syntax with `.chezmoi.os` conditions
- **Ignore rules**: `.chezmoiignore` conditionally excludes macOS-specific configs on non-macOS systems

### Core Components
- **Brewfile management**: `dot_Brewfile` contains Homebrew packages, casks, and VS Code extensions with automatic syncing
- **Neovim config**: LazyVim-based setup in `exact_dot_config/exact_nvim/`
- **Shell setup**: Zsh configuration with Starship prompt and fnm (Node.js manager)
- **Hammerspoon**: Lua-based macOS automation in `dot_hammerspoon/`

## Common Commands

### Chezmoi Operations
```bash
# Apply changes from the repository
chezmoi apply

# Edit a file in the chezmoi source directory
chezmoi edit ~/.zshrc

# Add a new file to chezmoi management
chezmoi add ~/.newfile

# See what changes would be applied
chezmoi diff

# Update from the repository
chezmoi update
```

### Development Commands
```bash
# Homebrew package management (auto-updates dot_Brewfile)
brew install <package>
brew remove <package>

# Node.js version management
fnm use        # Switch to project's Node version
fnm install    # Install Node version

# Neovim
nvim           # Launch Neovim with LazyVim config
```

### Testing and Validation
```bash
# Verify chezmoi configuration
chezmoi verify

# Check what files chezmoi manages
chezmoi managed

# Preview changes before applying
chezmoi diff
chezmoi apply --dry-run
```

## File Patterns

### Conditional Installation
Files are conditionally installed based on OS using `.chezmoiignore`:
- macOS-specific configs (Hammerspoon, Brewfile, sketchybar, skhd, yabai) are excluded on non-macOS systems
- Use `{{- if ne .chezmoi.os "darwin" }}` template syntax for OS conditions

### Critical Paths
- Shell environment: `dot_zshrc`, `dot_zprofile`
- Homebrew packages: `dot_Brewfile` (auto-synced via custom brew function)
- Neovim configuration: `exact_dot_config/exact_nvim/`
- Environment variable `CHEZMOI_DIR` is set to `$HOME/.local/share/chezmoi`

## Neovim Configuration

The Neovim setup follows LazyVim structure:
- Entry point: `init.lua` → loads `lua/config/lazy.lua`
- Core configs: `lua/config/` (keymaps, options, autocmds, lazy.lua)
- Plugin specs: `lua/plugins/` (extras.lua, hls.lua, fsharp.lua)
- Uses lazy.nvim with LazyVim distribution
- Auto-updates plugins with checker enabled

### Language-Specific Setup

#### F# Development
The F# setup (`lua/plugins/fsharp.lua`) requires fsautocomplete LSP:
```bash
# Install fsautocomplete globally
dotnet tool install -g fsautocomplete

# Verify installation
fsautocomplete --version
```

Key features:
- FsAutoComplete LSP with .NET 9 support
- Ionide-vim integration for F# Interactive
- Debugging support via netcoredbg
- Tree-sitter syntax highlighting

## Important Implementation Details

- The custom `brew()` function in `dot_zshrc` wraps Homebrew to auto-update `dot_Brewfile` on install/remove operations
- Shell PATH includes: Homebrew (`/opt/homebrew/bin`), .NET tools, Python 3.9 user bin
- fnm (Fast Node Manager) is configured with `--use-on-cd` for automatic Node version switching
- Neovim lazy.nvim bootstrap clones from stable branch if not present