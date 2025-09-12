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

