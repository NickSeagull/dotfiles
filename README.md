# dotfiles

## Install on Windows

```powershell
winget install gsudo
winget install Bitwarden.CLI
```

Then restart terminal

```powershell
gsudo Set-ExecutionPolicy Unrestricted
iex "&{$(irm 'https://get.chezmoi.io/ps1')} init --apply 'https://github.com/NickSeagull/dotfiles.git'"
```

## Install on macOS/Linux

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply NickSeagull/dotfiles
```

## Kanata (Keyboard Remapper) — macOS Manual Setup

Kanata is installed via `cargo install kanata --features cmd` (not Homebrew, to enable the `cmd` shell execution feature).
The `run_once_setup-kanata-macos.sh` script copies LaunchDaemon plists and bootstraps the services.
However, several steps require **manual GUI interaction** on macOS:

### Prerequisites

1. **Install Karabiner-DriverKit-VirtualHIDDevice**
   - Download the [latest .pkg](https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/tree/main/dist) (v5.0.0+)
   - Double-click to install and follow the prompts
   - When prompted, go to System Settings to grant the system extension permission

### After `chezmoi apply`

The run_once script will install plists and bootstrap services (requires sudo).
Then complete these manual steps:

2. **Grant Input Monitoring permission**
   - System Settings → Privacy & Security → Input Monitoring
   - Click `+` and add `~/.cargo/bin/kanata` (use Shift+Cmd+G to type the path)
   - Also add your terminal app (e.g., Ghostty)

3. **Grant Accessibility permission**
   - System Settings → Privacy & Security → Accessibility
   - Click `+` and add `~/.cargo/bin/kanata` and your terminal app

4. **Select the virtual keyboard**
   - System Settings → Keyboard → Keyboard Shortcuts → Modifier Keys
   - Select `Karabiner DriverKit VirtualHIDKeyboard` from the keyboard dropdown

5. **Start services (or reboot)**
   ```bash
   sudo launchctl start com.nick.karabiner-vhidmanager
   sudo launchctl start com.nick.karabiner-vhiddaemon
   sudo launchctl start com.nick.kanata
   ```

### Kanata Config

The config lives at `~/.config/kanata/kanata.kbd` (managed by chezmoi template).
Modifier layers:
- `e` (hold) = Cmd on macOS, Ctrl on Windows
- `a` (hold) = Ctrl on both platforms
- `q` (hold) = Cmd+Shift on macOS, Ctrl+Shift on Windows
- `;` (hold) = Shift
- `Caps Lock` = tap: Escape, hold: Ctrl

### Troubleshooting

 **Kanata binary changed after `cargo install` upgrade**: Re-add `~/.cargo/bin/kanata` in Input Monitoring
- **Check logs**: `sudo cat /Library/Logs/Kanata/kanata.err.log`
- **Test manually**: `sudo kanata -c ~/.config/kanata/kanata.kbd`
- **Restart service**: `sudo launchctl stop com.nick.kanata && sudo launchctl start com.nick.kanata`
