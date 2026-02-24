# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## Repository Overview
Multi-layered dotfiles repository managed by chezmoi, combining:
- Chezmoi templating for cross-platform configuration management
- Homebrew for macOS package management with auto-syncing
- Nix/Home Manager for declarative package configuration
- Neovim (LazyVim) editor configuration
- Kanata for cross-platform keyboard remapping

## Key Architecture
### Chezmoi Structure
- **dot_** prefix: Files that become dotfiles (e.g., `dot_zshrc` → `~/.zshrc`)
- **exact_** prefix: Directories managed exactly as-is
- **run_once_** prefix: Scripts executed once on initial setup
- **Templates** (`.tmpl` suffix): Go template syntax with `.chezmoi.os` conditions
- **Ignore rules**: `.chezmoiignore` conditionally excludes OS-specific configs
- **External repos**: `.chezmoiexternal.toml` manages external configurations
1. **Homebrew**: Primary macOS packages with custom auto-sync wrapper in `dot_zshrc`
2. **Nix/Home Manager**: Declarative system in `flake.nix` and `nix/hm.nix`
3. **Mason (Neovim)**: LSP servers and development tools
- **Neovim**: LazyVim-based setup in `exact_dot_config/exact_nvim/`
### Keyboard Remapping (Kanata)
- **Config**: `dot_config/kanata/kanata.kbd.tmpl` (chezmoi template, platform-aware)
- **macOS autostart**: LaunchDaemon plists in `dot_config/kanata/launchdaemons/`
- **Setup script**: `run_once_setup-kanata-macos.sh.tmpl` (installs plists, bootstraps services)
- **Driver**: Karabiner-DriverKit-VirtualHIDDevice (manual .pkg install required)
- **Cross-platform modifiers**: Template uses `.chezmoi.os` to output `lmet` (Cmd) on macOS, `lctl` (Ctrl) on Windows
 **Layer keys**: e=primary modifier, a=Ctrl, q=primary+Shift, ;=Shift, CapsLock=Esc/Ctrl, z=Zellij nav, s=Utility
 **Live reload**: User can press `s+p` (hold s, tap p) to live-reload the kanata config after changes are applied
- **Approach**: nikivi-style simultaneous key layers (not homerow mods). Reference: `nikivi-keybindings-reference.md`

#### Kanata macOS Manual Steps (cannot be automated)
After `chezmoi apply`, user must manually:
1. Install Karabiner-DriverKit-VirtualHIDDevice .pkg from GitHub
2. System Settings → Privacy & Security → Input Monitoring → add `~/.cargo/bin/kanata` + terminal
3. System Settings → Privacy & Security → Accessibility → add kanata + terminal
4. System Settings → Keyboard → Modifier Keys → select Karabiner VirtualHIDKeyboard
5. Start services or reboot (see README.md)

#### Kanata Troubleshooting
 After `cargo install kanata --features cmd`, re-add kanata in Input Monitoring if the binary changed
- Logs: `/Library/Logs/Kanata/kanata.{out,err}.log`
- Manual test: `sudo kanata -c ~/.config/kanata/kanata.kbd`
 Kanata is installed via `cargo install kanata --features cmd` (NOT Homebrew) to enable shell command execution

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
./reload.sh                     # Rebuild home-manager and sync doom
home-manager switch --flake .#$(nix eval --impure --raw --expr 'builtins.currentSystem')
```

### Kanata
```bash
# Validate config
kanata --check --cfg ~/.config/kanata/kanata.kbd

# Test manually (macOS, needs sudo)
sudo kanata -c ~/.config/kanata/kanata.kbd

# Restart service (macOS)
sudo launchctl stop com.nick.kanata && sudo launchctl start com.nick.kanata

# Check logs
sudo cat /Library/Logs/Kanata/kanata.err.log
```
### Development Environment
```bash
# Node.js version management
fnm use                         # Auto-switches to project's Node version
fnm install <version>          # Install specific Node version
nvim                           # Opens with full LSP support
:Mason                         # Manage LSP servers and tools
:Lazy                          # Plugin management
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
- gopls LSP server (auto-installed via Mason)
- golangci-lint integration
- Debugging support configured
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
- **Kanata config**: `dot_config/kanata/kanata.kbd.tmpl` (template) → `~/.config/kanata/kanata.kbd`
- **Kanata plists**: `dot_config/kanata/launchdaemons/*.plist` → `/Library/LaunchDaemons/` (via run_once script)
- **Ghostty config**: `dot_config/ghostty/config`
 **Kanata cheatsheet scripts**: `dot_config/kanata/scripts/executable_show-cheatsheet.sh` (macOS) and `dot_config/kanata/scripts/Show-Cheatsheet.ps1` (Windows) — must be updated when kanata config changes
- **Environment variable**: `CHEZMOI_DIR=$HOME/.local/share/chezmoi`
- **Bitwarden integration**: Enabled for secrets management
## Implementation Details
- Custom `brew()` function wraps Homebrew to auto-update `dot_Brewfile` on install/remove
- Git autopush enabled in `chezmoi.toml` for automatic repository updates
- fnm configured with `--use-on-cd` for automatic Node version switching
- Neovim lazy.nvim bootstraps from stable branch if not present
- PATH includes: `/opt/homebrew/bin`, `.NET tools`, Python 3.9 user bin
- Mason auto-installs LSP servers on first Neovim launch for configured languages
- Kanata config is the FIRST chezmoi template (`.tmpl` file) in the repo
- Platform targets: macOS (primary) and Windows 11

## Agent Workflow Rules

**IMPORTANT**: This repository is managed by chezmoi. After editing ANY file in this repo, you MUST run:
```bash
chezmoi apply --force
```
This deploys changes from the source directory (`~/.local/share/chezmoi/`) to their target locations (e.g., `~/.config/`, `~/.zshrc`, etc.). Without this step, edits only exist in the source repo and are NOT active on the system.

**Kanata config changes**: After editing `dot_config/kanata/kanata.kbd.tmpl`:
1. Run `chezmoi apply --force` to deploy
2. Run `kanata --check --cfg ~/.config/kanata/kanata.kbd` to validate syntax
3. **Update cheatsheet scripts** (`dot_config/kanata/scripts/executable_show-cheatsheet.sh` and `Show-Cheatsheet.ps1`) to reflect any shortcut/layer/binding changes
4. Tell the user to press `s+p` (hold s, tap p) to live-reload the config