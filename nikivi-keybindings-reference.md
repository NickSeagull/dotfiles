# Nikita Voloboev (nikivi) — Keybindings & Automation Reference

> Source: [nikivdev/snaps/kar/config.ts](https://github.com/nikivdev/snaps/blob/main/kar/config.ts)
> Tool: [kar](https://github.com/nikivdev/kar) — Karabiner config manager written in TypeScript/Rust
> Philosophy: Every key is a layer. No traditional modifier chords. Simultaneous key presses activate layers.

## Architecture

nikivi's entire workflow revolves around [Karabiner-Elements](https://github.com/pqrs-org/Karabiner-Elements) configured via `kar`, a custom TypeScript-to-Karabiner compiler he wrote. The core idea is **simlayers** (simultaneous layers): you hold any key on the keyboard, and while held, every other key gains a new meaning. This effectively turns a standard keyboard into a device with 40+ layers, each accessible with zero modifier keys.

### Supporting Tools

| Tool | Role |
|---|---|
| **Karabiner-Elements** | Core key remapping engine (macOS) |
| **kar** | TypeScript config → Karabiner JSON compiler |
| **seq** | His own low-latency automation daemon (socket-based commands) |
| **Keyboard Maestro** | Complex macros (text manipulation, app automation) |
| **Raycast** | App launcher + custom extensions |
| **Alfred** | Workflow triggers |
| **Zed** | Primary editor (opens files/dirs via keybindings) |
| **Cursor** | Secondary editor (GitHub workspace exploration) |

### Profile Settings

```
alone: 80ms        — tap-vs-hold threshold for layer keys
sim: 30ms          — simultaneous key press window (snappy chords)
simlayer threshold: 250ms — per-layer hold detection
```

### Simple Remappings

```
Caps Lock → Escape
; and : swapped (bare ; produces :, Shift+; produces ;)
```

---

## Core Layers (Essential)

### s-mode — Navigation & Editing ("the vim layer")

Hold `s`, press another key. This is the most important layer — used constantly.

| Key | Action | Notes |
|---|---|---|
| h | ← Left arrow | vim motion |
| j | ↓ Down arrow | vim motion |
| k | ↑ Up arrow | vim motion |
| l | → Right arrow | vim motion |
| d | Backspace | delete char |
| c | Cmd+Backspace | delete line (to start) |
| f | Enter | confirm/newline |
| ; | Shift+Enter | newline above/without submit |
| a | Cmd+C | copy |
| n | Cmd+V | paste |
| o | Cmd+X | cut |
| v | Left Shift (hold) | selection modifier |
| b | Cmd+← | beginning of line |
| m | Cmd+→ | end of line |
| e | Tab | next field |
| r | Shift+Tab | previous field |
| w | Opt+← then Opt+Shift+→ | select current word |
| ' | Cmd+← then Cmd+Shift+→ | select entire line |
| g | Cmd+Tab | switch app |
| [ | Lowercase selected text | via Keyboard Maestro |
| ] | Uppercase selected text | via Keyboard Maestro |
| / | Make markdown link from selection | via Keyboard Maestro |
| Space | Open kar config in Zed | quick config edit |

### e-mode — Cmd Modifier

Hold `e`, press any key → sends `Cmd+{key}`. Eliminates all Cmd chords.

| Key | Action |
|---|---|
| e + s | Cmd+S (save) |
| e + z | Cmd+Z (undo) |
| e + c | Cmd+C (copy) |
| e + v | Cmd+V (paste) |
| e + q | Cmd+Q (quit) |
| e + w | Cmd+W (close tab) |
| e + t | Cmd+T (new tab) |
| e + f | Cmd+F (find) |
| e + 1-9 | Cmd+1-9 (tab switching) |
| e + Space | Open Linear |
| e + Esc | Open Zed settings |
| ... | Every letter/number maps to Cmd+letter/number |

### q-mode — Cmd+Shift Modifier

Hold `q`, press any key → sends `Cmd+Shift+{key}`. For all Cmd+Shift shortcuts.

| Key | Action |
|---|---|
| q + 3 | Cmd+Shift+3 (screenshot) |
| q + 4 | Cmd+Shift+4 (area screenshot) |
| q + p | Cmd+Shift+P (command palette) |
| q + Space | Cmd+Opt+Shift+N |
| ... | Every letter/number maps to Cmd+Shift+letter/number |

### a-mode — Ctrl Modifier

Hold `a`, press any key → sends `Ctrl+{key}`. For all Ctrl shortcuts.

| Key | Action |
|---|---|
| a + 2 | Ctrl+2 |
| a + 3 | Ctrl+3 |
| ... | Every letter/number maps to Ctrl+letter/number |

### semicolon-mode — Shift (letters) / Ctrl (numbers)

Hold `;`, press a letter → Shift+letter (uppercase). Press a number → Ctrl+number.

| Key | Action |
|---|---|
| ; + a-z | Shift+letter (capitalization without Shift key) |
| ; + 1-9 | Ctrl+number |
| ; + Esc | Open ~/code/nikiv/do.md in Zed |
| ; + Cmd | Open Notion |
| ; + Space | Open ~/code/nikiv in Zed |

---

## App Launcher Layers

### w-mode — Primary Apps

Hold `w` to launch apps:

| Key | App |
|---|---|
| j | Ghostty (terminal) |
| k | Safari |
| l | Zed Preview |
| ; | Cursor |
| ' | JuxtaCode |
| a | Xcode |
| d | Fantastical |
| f | Things (tasks) |
| e | Comet |
| r | 1Password |
| t | Activity Monitor |
| h | Proxyman |
| v | TablePlus |
| b | OrbStack |
| n | Rise |
| m | Repo Prompt |
| o | Keyboard Maestro |
| Esc | Finder |
| . | Yaak (API client) |
| / | Sublime Merge |
| c | Conar |

### f-mode — Communication + AI (from config.ts)

Hold `f` for communication apps, AI tools, and design:

| Key | App/Action | Notes |
|---|---|---|
| h | Telegram (nikivdev chat) | Primary comms via `seqSocket` |
| u | Telegram (log channel) | |
| i | Telegram (nikivdev channel) | |
| g | Discord (in Arc) | Temporary binding |
| d | ChatGPT | |
| l | Claude | |
| w | Figma Beta | |
| a | Google Chrome Canary | |
| s | Eagle | Asset management |
| j | Preview | |
| o | x.com (in Arc) | Opens via seq macro |
| tab | tldraw | |

### d-mode — Media + Mouse Controls (from config.ts)

Hold `d` for media playback, volume, brightness, and mouse:

| Key | Action | Notes |
|---|---|---|
| ; | Spotify (or search) | via `seqSocket` |
| h | Previous track | |
| k | Play/Pause | |
| l | Next track | |
| n | Volume down | |
| m | Volume up | |
| tab | Mute | |
| q | Brightness down (keyboard) | |
| w | Brightness up (keyboard) | |
| e | Brightness down (display) | |
| esc | Brightness up (display) | |
| v | Mouse click (button 1) | |
| b | Mouse middle click (button 3) | |
| z | Mouse right click (button 2) | |

### r-mode — Secondary Apps

Hold `r` to launch less-used apps:

| Key | App |
|---|---|
| j | Preview |
| k | Photos |
| l | LM Studio |
| ; | Final Cut Pro |
| w | IINA (video) |
| e | System Settings |
| q | Craft |
| o | OBS |
| p | PDF Expert |
| n | Blender |
| m | Lightroom |
| . | DaVinci Resolve |
| a | Alfred Preferences |
| g | Pages |
| i | Voice Memos |
| Tab | Transmission |
| Esc | Darkroom |
| / | Developer |
| Space | Glide |

---

## Symbol Layer

### i-mode — Symbols

Hold `i` to type symbols without Shift or reaching:

| Key | Symbol | Notes |
|---|---|---|
| 1 | ! | Shift+1 |
| 2 | @ | Shift+2 |
| 3 | + | Shift+= |
| 4 | * | Shift+8 |
| w | ( | Shift+9 |
| e | # | Shift+3 |
| q | { | Shift+[ |
| r | " | Shift+' |
| t | ' | single quote |
| o | [ | open bracket |
| p | ] | close bracket |
| [ | } | Shift+] |
| a | / | slash |
| s | _ | Shift+- |
| d | \\ | backslash |
| f | - | hyphen |
| g | $ | Shift+4 |
| h | € | paste euro sign |
| j | = | equal sign |
| l | -> (space) | arrow sequence |
| ; | ; | literal semicolon (since ; is swapped to :) |
| z | ? | Shift+/ |
| x | \| | Shift+\\ (pipe) |
| c | & | Shift+7 |
| v | < | Shift+, |
| b | // (space) | comment prefix sequence |
| \` | ~ | tilde |

---

## Website / URL Layers

### tab-mode — Websites

Hold `Tab` to open sites in browser:

| Key | Site |
|---|---|
| w | Swift Forum |
| t | T3 Chat |
| u | SoundCloud |
| i | Le Chat |
| o | Bolt |
| h | Product Hunt |
| j | Midjourney |
| k | Grok Imagine |
| l | Sora |
| ; | Backpack Exchange |
| c | Chef |
| v | VSCO |
| b | Uber |
| n | Coinbase |
| . | Elk (Mastodon) |

### u-mode — More Websites

| Key | Site |
|---|---|
| q | Qwen |
| w | GitHub Map |
| e | Gel |
| r | ArXiv |
| i | Pinboard (popular) |
| s | VS |
| d | Map of Reddit |
| f | Cronometer |
| c | Convex |
| v | ElevenLabs |
| b | Grafbase |
| Esc | Vercel Domains |
| Space | RuTracker |

### backslash-mode — Dev Sites

| Key | Site |
|---|---|
| c | CodeSandbox |
| a | Val Town |
| ; | Repl.it |

---

## Developer Workflow Layers

### 3-mode — Localhost Ports

Hold `3` to open localhost on different ports:

| Key | URL |
|---|---|
| j | localhost:3000 |
| k | localhost:nikiv |
| r | localhost:fr |
| i | localhost:linsa |
| o | localhost:la |
| h | localhost:ghost |
| ; | localhost:gen |
| . | localhost:api |
| / | localhost:sb |
| Space | localhost:ui |

### 5-mode — Language Switching (Dash profiles)

| Key | Language |
|---|---|
| j | TypeScript |
| k | Go |
| n | Python |
| 3 | Rust |
| Space | Swift |

### 1-mode — Repo Prompts

| Key | Repo |
|---|---|
| f | flow |
| j | 1f |
| k | nikiv |
| l | linsa |
| ; | new |
| Space | x |

### 2-mode — Movement + Cmd Arrow Navigation

| Key | Action |
|---|---|
| h | Cmd+← (start of line/top) |
| j | Cmd+↓ (bottom) |
| k | Cmd+↑ (top) |
| l | Cmd+→ (end of line/bottom) |
| ; | Opt+↑ (move line up) |
| ' | Opt+↓ (move line down) |

### 4-mode — Scroll

| Key | Action |
|---|---|
| j | Scroll down (mouse wheel 60) |
| k | Scroll up (mouse wheel -60) |

---

## Simultaneous Key Chords

These fire when two keys are pressed at the same time (not held):

| Chord | Action |
|---|---|
| j+k | Open Safari new tab |
| k+n | Open Comet new tab |
| k+m | New Linear task |
| j+l | Cmd+Space (assistant/Spotlight) |
| k+l | Ctrl+Opt+Cmd+Space |
| j+; | Cmd+Opt+Shift+9 |
| l+m | Raycast: fork internal search |
| l+n | Raycast: flow index |

---

## GitHub Workspace Layers

Numbers 7-9, 0, hyphen, equal sign, brackets, and y-mode are all dedicated to opening GitHub codebases in Cursor workspaces. Examples:

### 7-mode (Rust-heavy)

| Key | Workspace |
|---|---|
| r | brush-gh |
| f | folo-rs-gh |
| c | calloop-rs-gh |

### 8-mode (Mixed)

| Key | Workspace |
|---|---|
| q | quic-go-gh |
| e | elevenlabs-gh |
| r | rig-gh |
| s | goose-gh |
| k | anki-gh |

### y-mode (More workspaces)

| Key | Workspace |
|---|---|
| w | workos-gh |
| o | leptos-gh |
| h | authkit-gh |
| k | kanidm-gh |
| m | axum-gh |

*(There are 6+ layers dedicated to ~100+ GitHub workspace shortcuts)*

---

## Infrastructure Layer

### o-mode — Cloud/Infra

| Key | Action |
|---|---|
| 1-6 | Cmd+1-6 (tab switching) |
| w | Neon Console |
| e | Vercel |
| Space | Railway |

---

## Design Principles

### 1. Every key is a layer
Nearly every key on the keyboard (a-z, 0-9, punctuation, modifiers) has a simlayer. This creates an enormous address space — roughly 40 layers × 40 keys = 1,600 possible bindings.

### 2. No traditional modifier chords
Instead of Cmd+S, you press `e` (hold) + `s`. Instead of Cmd+Shift+P, you press `q` (hold) + `p`. The fingers never leave home row for modifiers.

### 3. Mnemonic key assignments
- `s` = essential (vim-like, **s**-mode for navigation is the **s**tarting point)
- `e` = Cmd (**e**xecute commands)
- `q` = Cmd+Shift (next to `e`, adds **shift**)
- `a` = Ctrl (**a**-mode for control)
- `w` = apps (**w**indow/app launcher)
- `i` = symbols (**i**nput symbols)
- `tab` = websites (**tab** → browser tab)

### 4. Simultaneous press, not hold-then-press
The default simlayer mode is "simultaneous" — you press the layer key and target key at nearly the same time (within 250ms). This feels faster than hold-then-press.

### 5. Heavy use of automation daemons
Many bindings don't just press keys — they trigger:
- Keyboard Maestro macros (`km()`)
- Shell commands (`shell()`)
- Socket commands to `seq` daemon (`seqSocket()`)
- Raycast extensions (`raycast()`)
- Direct app opens (`openApp()`)
- Zed editor file opens (`zed()`)

### 6. Workspace-centric GitHub exploration
A huge portion of bindings (layers 7, 8, 9, 0, -, =, [, ], y) are dedicated to opening specific open-source GitHub repos in Cursor, suggesting a workflow of rapidly reading/exploring codebases.

---

## Tools & Repos

| Repo | Description |
|---|---|
| [nikivdev/kar](https://github.com/nikivdev/kar) | Karabiner config compiler (TS → JSON) |
| [nikivdev/snaps](https://github.com/nikivdev/snaps) | Config snapshots (kar/config.ts is the source of truth) |
| [nikivdev/config](https://github.com/nikivdev/config) | Public config (fish shell, zed, cursor, flow) |
| [nikivdev/seq](https://github.com/nikivdev/seq) | Low-latency automation daemon |
| [nikivdev/flow](https://github.com/nikivdev/flow) | Task runner / workflow manager |

---

*Last updated: 2026-02-23. Sourced from nikivdev/snaps/kar/config.ts (public snapshot).*