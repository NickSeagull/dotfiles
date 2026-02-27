# Starship prompt
Invoke-Expression (&starship init powershell)

# Aliases — override PowerShell built-in aliases for cat/ls
if (Test-Path Alias:cat) { Remove-Item Alias:cat -Force }
if (Test-Path Alias:ls)  { Remove-Item Alias:ls  -Force }
function cat { bat @args }
function ls  { eza @args }
