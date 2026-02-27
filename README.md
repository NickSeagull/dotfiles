# dotfiles

Cross-platform dotfiles managed by [chezmoi](https://www.chezmoi.io/), targeting Windows 11 and macOS.

## Install on Windows

Fresh Windows 11 machine. Follow these steps in order.

### Prerequisites

- Git (you already have it if you cloned this repo)
- winget (ships with Windows 11 — if missing, install from the Microsoft Store)

### Step 1: Core Tools

```powershell
winget install gsudo
winget install Bitwarden.CLI
```

Restart your terminal, then:

```powershell
gsudo Set-ExecutionPolicy Unrestricted
```

### Step 2: Set XDG_CONFIG_HOME

Neovim and other XDG-aware tools default to `%LOCALAPPDATA%` on Windows, not `~/.config/`. Setting this variable makes configs work the same way across platforms.

```powershell
[Environment]::SetEnvironmentVariable('XDG_CONFIG_HOME', "$env:USERPROFILE\.config", 'User')
```

Restart your terminal after this. The variable won't be picked up until you do.

### Step 3: Install and Apply Chezmoi

```powershell
iex "&{$(irm 'https://get.chezmoi.io/ps1')} init --apply 'https://github.com/NickSeagull/dotfiles.git'"
```

This pulls the repo and deploys all files to their target locations. Chezmoi has Bitwarden integration enabled in `chezmoi.toml`, so it will prompt you to unlock your vault. If you don't use Bitwarden, edit `~/.config/chezmoi/chezmoi.toml` and remove the Bitwarden data source.

### Step 4: Terminal Emulator (WezTerm)

Ghostty isn't available on Windows. WezTerm is the recommended alternative: GPU-accelerated, cross-platform, Lua-configurable, with excellent font rendering and ligature support.

```powershell
winget install wez.wezterm
```

The kanata app-launcher shortcut (hold `w`, tap `j`) will focus or launch WezTerm on Windows.

### Step 5: Neovim

```powershell
winget install Neovim.Neovim
```

LazyVim and all plugins bootstrap automatically on first launch. Mason LSP servers are not auto-installed. Open Neovim and run `:Mason` to install the language servers you need.

Requires `XDG_CONFIG_HOME` from Step 2. Without it, Neovim won't find the config at `~/.config/nvim/`.

### Step 6: Kanata (Keyboard Remapper)

Two options:

**Option A: Pre-built binary (recommended)**

1. Download the latest release from https://github.com/jtroo/kanata/releases
2. From `windows-binaries-x64.zip`, extract `kanata_windows_x64_tty_cmd_allowed_winIOv2.exe`
3. Rename it to `kanata.exe` and place it somewhere permanent, e.g. `C:\tools\kanata.exe`

**Option B: Build from source**

```powershell
winget install Rustlang.Rustup
rustup default stable
cargo install kanata --features cmd
```

**Test it:**

```powershell
kanata.exe --cfg "$env:USERPROFILE\.config\kanata\kanata.kbd"
```

**Autostart on login (registry run key, starts hidden):**

```powershell
# Adjust $kanataPath to wherever you put kanata.exe
$kanataPath = "C:\tools\kanata.exe"  # or "$env:USERPROFILE\.cargo\bin\kanata.exe" if built from source
$cfgPath = "$env:USERPROFILE\.config\kanata\kanata.kbd"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v Kanata /t REG_SZ /d """C:\Windows\System32\conhost.exe"" --headless ""$kanataPath"" --cfg ""$cfgPath""" /f
```

Notes:
- The `winIOv2` variant uses Windows low-level hooks. No driver installation needed.
- No admin privileges required for normal use.
- Admin is only needed if you want kanata to intercept keys in elevated windows (Task Manager, admin PowerShell).
- For a system tray icon, use `kanata_windows_x64_gui_cmd_allowed_winIOv2.exe` instead and place a shortcut in `shell:startup`.

### Step 7: Zellij (via WSL)

Zellij doesn't run natively on Windows. Install it inside WSL:

```bash
# Inside WSL
curl -L https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz | tar xz -C ~/.local/bin
```

Then symlink the chezmoi-deployed config from Windows into WSL:

```bash
mkdir -p ~/.config
ln -sf "/mnt/c/Users/$(cmd.exe /c echo %USERNAME% 2>/dev/null | tr -d '\r')/.config/zellij" ~/.config/zellij
```

### Step 8: Optional Tools

These are referenced in configs or useful for the full experience:

```powershell
winget install Starship.Starship          # Cross-shell prompt
winget install sharkdp.bat                # cat with syntax highlighting
winget install eza-community.eza          # ls replacement
winget install Rustlang.Rustup            # Rust toolchain (needed for kanata from source)
winget install OpenJS.NodeJS.LTS          # Node.js (or use fnm)
```

### What Gets Deployed on Windows

| Path | Description |
|------|-------------|
| `~/.gitconfig` | Git configuration |
| `~/.config/kanata/kanata.kbd` | Kanata keyboard remapper config |
| `~/.config/kanata/scripts/*.ps1` | PowerShell helper scripts for kanata |
| `~/.config/nvim/` | Neovim (LazyVim) configuration |
| `~/.config/opencode/` | OpenCode AI assistant configuration |
| `~/.config/zellij/` | Zellij config (for WSL symlink) |
| `~/.config/themes/` | Color theme definitions |
| `~/colorscheme.json` | Freshcut Contrast color scheme reference |

### What's Excluded on Windows

- Shell configs (`.zshrc`, `.zprofile`) — Windows uses PowerShell
- Homebrew / Brewfile — macOS package manager
- Ghostty config — not available on Windows
- Sketchybar — macOS menu bar customization
- AeroSpace config — macOS tiling window manager
- Kanata LaunchDaemons — macOS service management
- Keymapper — Android keyboard remapping generator
- Shell scripts (`.sh`) — macOS/Linux only

## Install on macOS/Linux

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply NickSeagull/dotfiles
```

## Kanata (Keyboard Remapper)

### Kanata Config

The config lives at `~/.config/kanata/kanata.kbd`, managed by a chezmoi template that outputs the correct modifier keys per platform.

Modifier layers:
- `e` (hold) = Cmd on macOS, Ctrl on Windows
- `a` (hold) = Ctrl on both platforms
- `q` (hold) = Cmd+Shift on macOS, Ctrl+Shift on Windows
- `;` (hold) = Shift
- `Caps Lock` = tap: Escape, hold: Ctrl

Live reload: hold `s`, tap `p`.

### macOS Setup

Kanata is installed via `cargo install kanata --features cmd` (not Homebrew, to enable the `cmd` shell execution feature). The `run_once_setup-kanata-macos.sh` script copies LaunchDaemon plists and bootstraps the services. Several steps require manual GUI interaction.

**Prerequisites**

1. **Install Karabiner-DriverKit-VirtualHIDDevice**
   - Download the [latest .pkg](https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/tree/main/dist) (v5.0.0+)
   - Double-click to install and follow the prompts
   - When prompted, go to System Settings to grant the system extension permission

**After `chezmoi apply`**

The run_once script installs plists and bootstraps services (requires sudo). Then complete these steps manually:

2. **Grant Input Monitoring permission**
   - System Settings > Privacy & Security > Input Monitoring
   - Click `+` and add `~/.cargo/bin/kanata` (use Shift+Cmd+G to type the path)
   - Also add your terminal app (e.g., Ghostty)

3. **Grant Accessibility permission**
   - System Settings > Privacy & Security > Accessibility
   - Click `+` and add `~/.cargo/bin/kanata` and your terminal app

4. **Select the virtual keyboard**
   - System Settings > Keyboard > Keyboard Shortcuts > Modifier Keys
   - Select `Karabiner DriverKit VirtualHIDKeyboard` from the keyboard dropdown

5. **Start services (or reboot)**
   ```bash
   sudo launchctl start com.nick.karabiner-vhidmanager
   sudo launchctl start com.nick.karabiner-vhiddaemon
   sudo launchctl start com.nick.kanata
   ```

### Windows Setup

Chezmoi deploys the config to `~/.config/kanata/kanata.kbd`. See [Step 6](#step-6-kanata-keyboard-remapper) above for installation and autostart.

Key points:
- The `winIOv2` variant uses Windows low-level hooks. No driver installation needed.
- Always pass the config path explicitly: `kanata.exe --cfg path\to\kanata.kbd`
- Live reload: hold `s`, tap `p`

### Troubleshooting

**macOS**
- Kanata binary changed after `cargo install` upgrade: re-add `~/.cargo/bin/kanata` in Input Monitoring
- Check logs: `sudo cat /Library/Logs/Kanata/kanata.err.log`
- Test manually: `sudo kanata -c ~/.config/kanata/kanata.kbd`
- Restart service: `sudo launchctl stop com.nick.kanata && sudo launchctl start com.nick.kanata`

**Windows**
- Test manually: `kanata.exe --cfg "$env:USERPROFILE\.config\kanata\kanata.kbd"`
- Watch the console output for errors — kanata prints exactly what's wrong
- If keys stop working after a Windows update, re-run the autostart registry command from Step 6
