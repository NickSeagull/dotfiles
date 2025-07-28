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
- **Brewfile management**: `dot_Brewfile` contains Homebrew packages, casks, and VS Code extensions
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

### Homebrew Integration
The repository includes a custom `brew()` function in `dot_zshrc` that automatically updates the Brewfile when packages are installed/removed:
```bash
brew install package_name  # Automatically updates dot_Brewfile
brew remove package_name   # Automatically updates dot_Brewfile
```

### Development Environment
- **Node.js**: Managed via fnm (Fast Node Manager)
- **Editor**: Neovim with LazyVim configuration
- **Shell**: Zsh with Starship prompt

## File Patterns

### Conditional Installation
Files are conditionally installed based on OS using `.chezmoiignore`:
- macOS-specific configs (Hammerspoon, Brewfile) are excluded on non-macOS systems
- Use `{{- if ne .chezmoi.os "darwin" }}` template syntax for OS conditions

### Neovim Configuration
The Neovim setup follows LazyVim structure:
- `init.lua`: Entry point
- `lua/config/`: Core configuration (keymaps, options, autocmds)
- `lua/plugins/`: Plugin configurations
- Uses lazy.nvim for plugin management

## Important Notes

- The repository manages system-level configurations, so changes affect the entire development environment
- Brewfile automatically syncs with actual installed packages via the custom brew function
- Neovim config is based on LazyVim starter template
- Shell configuration includes Node.js version management via fnm