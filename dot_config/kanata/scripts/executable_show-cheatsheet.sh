#!/bin/bash
# Show kanata layer cheatsheet as a macOS dialog (press OK or Enter/Space to dismiss)
# Usage: show-cheatsheet.sh <layer>
# Layers: w, f, d, z, s

LAYER="$1"

case "$LAYER" in
  w)
    TITLE="w-mode — App Launcher"
    TEXT="Hold w + tap key to focus/launch app

j = Ghostty          k = Firefox
r = Bitwarden        d = Spark (email)
f = TickTick          t = Activity Monitor
Esc = Finder"
    ;;
  f)
    TITLE="f-mode — Communication"
    TEXT="Hold f + tap key to focus/launch app

j = Brave Browser    h = Telegram
k = Discord            l = Claude
d = WhatsApp"
    ;;
  d)
    TITLE="d-mode — Media Controls"
    TEXT="Hold d + tap key for media control

h = Previous track    j = Play/Pause
k = Volume up          l = Next track
n = Volume down       ; = YouTube Music"
    ;;
  z)
    TITLE="z-mode — Zellij Navigation"
    TEXT="Hold z + tap key for Zellij shortcut

h/j/k/l = Pane nav (Alt+hjkl)
y/u/i/o = Move pane (Alt+Shift+hjkl)
n = New pane          p = Session manager
= / - = Resize         Space = Command layer

Session quick-switch:
x = neohaskell        c = neclau
v = CIOS                6 = nh-website
0 = dotfiles"
    ;;
  s)
    TITLE="s-mode — Utility"
    TEXT="Hold s + tap key for utility actions

p = Live reload kanata config"
    ;;
  *)
    TITLE="Kanata Cheatsheet"
    TEXT="Hold / + layer key to view cheatsheet

w = App launcher      f = Communication
d = Media controls   z = Zellij navigation
s = Utility"
    ;;
esac

osascript -e "display dialog \"$TEXT\" with title \"$TITLE\" buttons {\"OK\"}" &>/dev/null &