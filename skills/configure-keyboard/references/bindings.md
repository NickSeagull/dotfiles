# Accepted keyboard contract

The canonical decision is [Define held-letter behavior and the starter action
layers](https://plane.p.egregore.io/egregore/projects/e4709aa7-c911-4a7b-a9ec-f9eaa2bb905b/issues/ce516f80-0377-43e1-ba25-f5dd27575e81/).
Apply these requirements to this effort, not unrelated keyboard projects.

Use one key per hand: no starter action may require holding two keys with the
same hand. Choose the layer trigger opposite the action key. Do not stack
home-row modifiers or require Shift as a third physical key for selection.
Additional generic modifier-combination holds are deferred; a layer action may
emit a combined shortcut internally. Existing physical modifier keys remain
available.

Use deliberate 200 ms tap/hold behavior. Taps type their ordinary characters.
Another key before the threshold commits ordinary typing and cancels the hold
until the trigger is released; it must not activate later during that press.
Never activate a hold early merely because another key is pressed or released.
Releasing a trigger exits its layer or modifier role immediately. Holding a
trigger alone does not repeat its character. Test this behavior; rare trigger
letters and a timeout do not guarantee zero accidental activation during slow
overlapping typing.

Bindings are global, with no initial app-specific overrides. Preserve existing
modified typing and shortcuts, including Command+Space for Raycast and the
Ghostty/Herdr Command+E and Command+O behavior. Modified base-layer shortcuts must
not unexpectedly enter action layers. Bound layer actions take precedence over
base home-row modifier and trigger roles; do not nest layers. Unassigned keys
inside an active layer do nothing. Text movement/selection repeats while an
action key is held; app/window actions fire once per physical press.

### Home-row modifiers

| Modifier | Left hold | Right hold |
| --- | --- | --- |
| Shift | a | semicolon |
| Control | s | l |
| Option | d | k |
| Command | f | j |

### Mirrored action layers

| Layer | Left hold | Right hold |
| --- | --- | --- |
| Text navigation | z | slash |
| Window navigation | x | period |
| Common apps | c | comma |
| Messaging | v | m |
| Notes/reference | b | n |

Selection uses an additional mirrored g/h hold pair with the same movement keys
as navigation, but emits the selection variant of each action. Release the
trigger to stop extending selection; do not leave a selection mode or synthetic
modifier latched. For example, g+j selects down and h+w selects forward a word.

### Text actions

| Action keys | Movement |
| --- | --- |
| h / j / k / l | Left / down / up / right |
| b | Native backward-word movement |
| w / e | Aliases for native forward-word movement |
| 0 | Line start |
| 4 | Line end, using the dollar-sign position without physical Shift |

Use z+h/j/k/l and z+0 for right-hand actions; slash+w/b/e and slash+4 for
left-hand actions. Use g or h, respectively, for selection equivalents.
On macOS native backward/forward word shortcuts target word beginnings/ends;
the user accepted that w and e are aliases. Do not promise exact Vim w/b/e
semantics, a Vim command interpreter, editing operators or normal/insert modes.
Destination-app interpretation can differ; verify native behavior in runtime
tests instead of silently adding app-specific exceptions.

### App and window actions

Common apps: comma+b = Zen, comma+t = Ghostty, comma+e = VS Code.
Messaging: m+t = Telegram, m+e = Element.
Notes/reference: b+n = Notion, b+o = Obsidian.
Each action launches its target or focuses it if running. It must not hide or
quit an already focused app.

Windows: x+h = previous app, x+l = next app; x+j = next window within the
current app, x+k = previous window within it. Maintain a stable cycle order
during one layer hold so repeated presses advance through the list instead of
toggling two apps. The macOS adapter keeps stable app and window snapshots for the held session; see [mechanisms](mechanisms.md).
Mission Control and window placement actions are excluded from these layers;
Raycast stays on Command+Space. Preserve the separate Moom placement preference.
