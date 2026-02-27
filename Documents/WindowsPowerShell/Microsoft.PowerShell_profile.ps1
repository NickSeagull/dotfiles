# Starship prompt
Invoke-Expression (&starship init powershell)

# Aliases
Remove-Alias cat -Force -ErrorAction SilentlyContinue
Remove-Alias ls  -Force -ErrorAction SilentlyContinue
function cat { bat @args }
function ls  { eza @args }
