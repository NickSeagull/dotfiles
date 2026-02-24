# Kanata Keyboard Cheatsheet

> nikivi-style simultaneous key layers — hold a key to activate its layer, tap for the normal letter.
>
> This file is auto-maintained. When kanata config changes, this cheatsheet MUST be updated.

## Modifier Keys

All modifiers: **tap** = normal letter, **hold** = modifier.

| Key | Tap | Hold | Notes |
|-----|-----|------|-------|
| `Caps Lock` | Escape | Ctrl | Vim escape + terminal Ctrl |
| `e` | e | Cmd (macOS) / Ctrl (Win) | Primary modifier |
| `a` | a | Ctrl | Both platforms — terminal/vim shortcuts |
| `q` | q | Cmd+Shift (macOS) / Ctrl+Shift (Win) | Primary + Shift |
| `;` | ; | Shift | Hold + letter = uppercase |

## Layer Keys

All layers: **tap** = normal letter, **hold** = activate layer.

| Key | Tap | Hold (Layer) |
|-----|-----|--------------|
| `w` | w | App launcher (w-mode) |
| `f` | f | Communication (f-mode) |
| `d` | d | Media controls (d-mode) |
| `z` | z | Zellij navigation (z-mode) |
| `s` | s | Utility (s-mode) |

## w-mode — App Launcher

Hold `w` + tap key to focus or launch an app.

| Key | App |
|-----|-----|
| `j` | Ghostty |
| `k` | Firefox |
| `r` | Bitwarden |
| `d` | Spark (email) |
| `f` | TickTick |
| `t` | Activity Monitor |
| `Esc` | Finder |

## f-mode — Communication

Hold `f` + tap key to focus or launch a communication/browser app.

| Key | App |
|-----|-----|
| `j` | Brave Browser |
| `h` | Telegram |
| `k` | Discord |
| `l` | Claude |
| `d` | WhatsApp |

## d-mode — Media Controls

Hold `d` + tap key for media control (vim-spatial layout).

| Key | Action |
|-----|--------|
| `h` | Previous track |
| `j` | Play / Pause |
| `k` | Volume up |
| `l` | Next track |
| `n` | Volume down |
| `;` | YouTube Music (focus/launch) |

## z-mode — Zellij Navigation

Hold `z` + tap key for Zellij terminal multiplexer shortcuts.

### Pane Navigation

| Key | Action | Sends |
|-----|--------|-------|
| `h` | Move left | Alt+h |
| `j` | Move down | Alt+j |
| `k` | Move up | Alt+k |
| `l` | Move right | Alt+l |

### Pane Management

| Key | Action | Sends |
|-----|--------|-------|
| `n` | New pane | Alt+n |
| `p` | Session manager | Alt+p |
| `=` | Resize grow | Alt+= |
| `-` | Resize shrink | Alt+- |
| `Space` | Command layer | Ctrl+g |

### Session Quick-Switch

| Key | Session |
|-----|---------|
| `x` | neohaskell |
| `c` | neclau |
| `v` | CIOS |
| `6` | nh-website |
| `7` | (unassigned) |
| `8` | (unassigned) |
| `9` | (unassigned) |
| `0` | dotfiles |

## s-mode — Utility

Hold `s` + tap key for utility actions.

| Key | Action |
|-----|--------|
| `p` | Live reload kanata config |

## Global

| Shortcut | Action |
|----------|--------|
| `Ctrl+Space+Esc` | Force quit kanata (defsrc keys, before remap) |