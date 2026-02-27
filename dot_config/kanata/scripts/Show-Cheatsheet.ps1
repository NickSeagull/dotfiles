# Show kanata layer cheatsheet as a Windows popup (press OK or Enter/Space to dismiss)
# Usage: Show-Cheatsheet.ps1 <layer>
# Layers: w, f, d, z, s

param([string]$Layer)

switch ($Layer) {
    'w' {
        $Title = 'w-mode - App Launcher'
        $Text = @"
Hold w + tap key to focus/launch app

j = Ghostty          k = Firefox
r = Bitwarden        d = Spark (email)
f = TickTick          t = Activity Monitor
Esc = Finder
"@
    }
    'f' {
        $Title = 'f-mode - Communication'
        $Text = @"
Hold f + tap key to focus/launch app

j = Brave Browser    h = Telegram
k = Discord            l = Claude
d = WhatsApp
"@
    }
    'd' {
        $Title = 'd-mode - Media Controls'
        $Text = @"
Hold d + tap key for media control

h = Previous track    j = Play/Pause
k = Volume up          l = Next track
n = Volume down       ; = YouTube Music
"@
    }
    'z' {
        $Title = 'z-mode - Zellij Navigation'
        $Text = @"
Hold z + tap key for Zellij shortcut

h/j/k/l = Pane nav (Alt+hjkl)
y/u/i/o = Move pane (Alt+Shift+hjkl)
n = New pane          p = Session manager
= / - = Resize         Space = Command layer

Session quick-switch:
x = neohaskell        c = neclau
v = CIOS                6 = nh-website
0 = dotfiles
"@
    }
    's' {
        $Title = 's-mode - Utility'
        $Text = @"
Hold s + tap key for utility actions

p = Live reload kanata config
"@
    }
    default {
        $Title = 'Kanata Cheatsheet'
        $Text = @"
Hold / + layer key to view cheatsheet

w = App launcher      f = Communication
d = Media controls   z = Zellij navigation
s = Utility
"@
    }
}

$wsh = New-Object -ComObject WScript.Shell
$wsh.Popup($Text, 0, $Title, 0) | Out-Null