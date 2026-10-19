# Keyboard reference

Hold the first key for **200 ms**, then press the action key with the opposite
hand. Tapping types the ordinary character. Another key before the threshold
cancels that hold until release. Existing physical modifier shortcuts still work.

## Home-row modifiers

| Modifier | Left-hand hold | Right-hand hold |
| --- | --- | --- |
| Shift | `a` | `;` |
| Control | `s` | `l` |
| Option ⌥ | `d` | `k` |
| Command ⌘ | `f` | `j` |

For example, hold `j`, then tap `c` to copy with Command+C. Do not stack home-row
modifier holds.

## Text navigation and selection

| Action | Move: hold + action | Select: hold + action |
| --- | --- | --- |
| Left | `z` + `h` | `g` + `h` |
| Down | `z` + `j` | `g` + `j` |
| Up | `z` + `k` | `g` + `k` |
| Right | `z` + `l` | `g` + `l` |
| Previous word | `/` + `b` | `h` + `b` |
| Next word | `/` + `w` or `e` | `h` + `w` or `e` |
| Line start | `z` + `0` | `g` + `0` |
| Line end | `/` + `4` | `h` + `4` |

Word movement uses native macOS Option+arrow behavior; `w` and `e` are aliases.
Line start/end use Command+arrow. Selection adds Shift internally, so no third
physical key is needed. Hold an action key to repeat movement or selection;
release the trigger to stop immediately.

## Apps and windows

| Hold + action | Result |
| --- | --- |
| `,` + `b` | Launch or focus Zen |
| `,` + `t` | Launch or focus Ghostty |
| `,` + `e` | Launch or focus VS Code |
| `m` + `t` | Launch or focus Telegram |
| `m` + `e` | Launch or focus Element |
| `b` + `n` | Launch or focus Notion |
| `b` + `o` | Launch or focus Obsidian |
| `x` + `h` / `l` | Previous / next app |
| `x` + `j` / `k` | Next / previous window in the current app |

App/window actions fire once per action-key press. Keep the window layer held
and press again to continue cycling in a stable order. Focusing an already
focused app does not hide or quit it.

## Mirrored layer triggers

Both triggers activate the same action set; choose the one opposite the action
hand. The tables above show the intended opposite-hand combinations.

| Layer | Left-hand hold | Right-hand hold |
| --- | --- | --- |
| Text navigation | `z` | `/` |
| Text selection | `g` | `h` |
| Windows | `x` | `.` |
| Common apps | `c` | `,` |
| Messaging | `v` | `m` |
| Notes/reference | `b` | `n` |

Mapped actions take precedence over a key's modifier or layer-trigger role.
Unassigned keys do nothing inside a layer. Releasing its trigger exits the layer.

## Disable and recovery

| Key or command | Result |
| --- | --- |
| **Physical Left Control+Space+Escape** | Emergency stop; restore ordinary typing and persistently disable remapping |
| `keyboard disable` | Stop capture and persistently disable remapping |
| `keyboard enable` | Explicitly re-enable after checking prerequisites |
| `keyboard status` | Show disable reason, engine/runner state, and Accessibility permission |
| `keyboard permissions` | Request the action helper's Accessibility prompt |

Engine/runner failure also restores ordinary input and latches disable. Restarting
a service does not clear it; use explicit enable after resolving the cause.
