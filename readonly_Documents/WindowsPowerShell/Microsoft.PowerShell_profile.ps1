Clear-Host
Invoke-Expression (&starship init powershell)
function cmcd { Set-Location $(chezmoi source-path) }