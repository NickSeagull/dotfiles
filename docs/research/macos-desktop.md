# macOS desktop building blocks and configuration boundaries

Research date: **2026-10-14**, Atlantic/Canary. Planning evidence for [Assess macOS desktop building blocks and configuration boundaries](https://plane.p.egregore.io/egregore/projects/e4709aa7-c911-4a7b-a9ec-f9eaa2bb905b/issues/ded1dcf0-4c36-4b0e-923a-28c7ad836ac8/) in the [Shape a distinctive macOS daily driver inspired by Omarchy](https://plane.p.egregore.io/egregore/projects/e4709aa7-c911-4a7b-a9ec-f9eaa2bb905b/issues/7d839361-92ca-440f-b7b0-1e85f9b38167/) Wayfinder map. No desktop software was installed, enabled, or reconfigured during this research. Candidate architectures below are proposals for discussion, not adoption decisions.

## The decision this research makes possible

The central choice is **what a workspace means**. AeroSpace supplies its own fast, named workspaces; yabai operates on native macOS Spaces; a native/Raycast approach keeps manual arrangement and macOS navigation. This choice determines monitor behavior, fullscreen, window switching, the status bar, and what a “return to project” command must do. Choosing a palette or collecting utilities first would leave that interaction contract unresolved. This is the researcher's synthesis of the capabilities below.

There is a particularly consequential integration seam: **AeroSpace's guide recommends disabling “Displays have separate Spaces” for some focus/stability problems, whereas SketchyBar's setup requires it enabled, as does yabai.** This is not evidence that AeroSpace and SketchyBar cannot coexist—the AeroSpace project publishes their integration. It is evidence that the final plan must select and test a monitor policy, rather than combine unrelated defaults. [AeroSpace guide](https://nikitabobko.github.io/AeroSpace/guide#emulation-of-virtual-workspaces), [SketchyBar setup](https://felixkratz.github.io/SketchyBar/setup), [yabai requirements](https://github.com/asmvik/yabai#requirements-and-caveats), [AeroSpace integrations](https://nikitabobko.github.io/AeroSpace/goodies#show-aerospace-workspaces-in-sketchybar).

## Starting evidence and limits

The coordinating session observed a MacBook Pro Mac16,5, M4 Max, 48 GB, macOS **26.5.1**, with Ghostty **1.3.1** and an empty Ghostty configuration, Raycast **2.7.3.0**, AltTab **11.9.1**, Zen, VS Code and Docker installed, and Codex CLI available on PATH. Installation is not evidence of active use, permissions, subscription level, or satisfaction. Monitor arrangement, keyboard layout, fullscreen habits, and actual project-switching friction remain unknown. These machine observations were supplied by the parent session; this researcher did not independently interrogate personal app state.

Repository inspection at bootstrap commit `5c1f438b02209fb18c6e275215b60e212056e55d` confirms an `aarch64-darwin` nix-darwin configuration, Home Manager integration, empty `home.packages` and `home.file`, and `nix.enable = false` because Determinate owns Nix and its daemon/configuration. Git and gh are configured. The tracked files establish the intended baseline, not proof that a particular generation is currently active. [flake.nix](https://github.com/NickSeagull/dotfiles/blob/5c1f438b02209fb18c6e275215b60e212056e55d/flake.nix), [Darwin configuration](https://github.com/NickSeagull/dotfiles/blob/5c1f438b02209fb18c6e275215b60e212056e55d/hosts/corthan/darwin.nix), [Home Manager configuration](https://github.com/NickSeagull/dotfiles/blob/5c1f438b02209fb18c6e275215b60e212056e55d/hosts/corthan/home.nix).

**Compatibility evidence is documentation/source inspection, not testing on this Mac.** No benchmark, overnight sleep test, dock cycle, TCC permission migration, or interaction test has been performed. A minimum OS version or a package marked Darwin-compatible does not certify macOS 26.5.1.

| Component | Upstream anchor inspected | What that establishes |
|---|---|---|
| AeroSpace | [v0.21.3-Beta](https://github.com/nikitabobko/AeroSpace/releases/tag/v0.21.3-Beta), published 2026-07-16 | An explicitly beta release; do not treat current guide syntax as interchangeable with older packages |
| yabai | [v7.1.25](https://github.com/asmvik/yabai/releases/tag/v7.1.25), 2026-05-08 | Release identity; current README explicitly claims Apple Silicon Tahoe 26.0+ support |
| SketchyBar | [v2.24.1](https://github.com/FelixKratz/SketchyBar/releases/tag/v2.24.1), 2026-10-09 | Recent fixes for menu-bar height, notch reservation, display recreation, and client timeouts |
| JankyBorders | [v1.9.0](https://github.com/FelixKratz/JankyBorders/releases/tag/v1.9.0), 2026-05-14 | Release identity; README describes macOS 14+ support |
| Hammerspoon | [1.1.1](https://github.com/Hammerspoon/hammerspoon/releases/tag/1.1.1), 2026-02-26 | Minimum macOS 13; patch fixes archive contents that could confuse Gatekeeper |
| Ghostty | [1.3.1](https://ghostty.org/docs/install/release-notes/1-3-1), 2026-03-13 | Already installed version; fixes macOS focus-related phantom mouse events and window sizing regressions |
| AltTab | [v11.9.2](https://github.com/lwouis/alt-tab-macos/releases/tag/v11.9.2), 2026-10-13 | Upstream version newer than observed install; permissions examined against installed-version tag v11.9.1 |

Release dates were checked against official release metadata or release notes. Live documentation can describe newer behavior than a pinned binary; this is especially relevant to AeroSpace and Raycast's combined macOS/Windows manual.

## Window and workspace models

### AeroSpace: named workspaces without Dock injection

AeroSpace describes itself as an i3-like tree tiler with animation-free workspace switching and no requirement to disable SIP. Its advertised model is a deliberate replacement for native Spaces rather than an extension of them. The project remains beta. Accessibility-based control is still macOS window manipulation, not ownership of a Linux compositor. [Project README](https://github.com/nikitabobko/AeroSpace).

Its guide describes hiding inactive windows just beyond a display corner and bringing them back when their workspace becomes active. The intended arrangement is one native Space, or one per display. Monitors need a free lower corner; unsuitable geometry can expose hidden windows. Mission Control can show undersized previews. With separate Spaces disabled, native fullscreen can black out the other display. These are documented behavioral compromises, not observed defects on this machine. [Workspace mechanics and monitor caveats](https://nikitabobko.github.io/AeroSpace/guide#emulation-of-virtual-workspaces).

The command interface distinguishes AeroSpace fullscreen from `macos-native-fullscreen`, supports directional focus, moving windows/workspaces between monitors, querying windows/workspaces, and temporarily disabling management. `enable off` returns hidden workspace windows to the visible area and stops intercepting keys. These capabilities support a reviewable escape route and a project picker without requiring a custom tiling engine. [Command reference](https://nikitabobko.github.io/AeroSpace/commands).

**Candidate experience:** one project workspace contains an editor and terminal; a second arrangement holds browser/reference material; an agent-ready action returns to the precise working context. The project could alternatively keep editor/browser/terminal together. Both are plausible; allocating one workspace per app is not automatically right for a person switching between projects.

The official goodies page supplies SketchyBar workspace-change hooks, JankyBorders startup integration, a third-party Raycast extension, and gesture-tool examples. It also explains why simply opening an application can focus an existing window elsewhere instead of creating the desired new one. This is a useful integration recipe, not a complete desktop distribution. [AeroSpace goodies](https://nikitabobko.github.io/AeroSpace/goodies).

**Implementation obligations:** validate each app's dialogs and transient windows; exercise Zen video fullscreen, Ghostty quick terminal, VS Code dialogs, and agent permission sheets. Avoid rules that assume titles exist immediately. Test AltTab's scope against AeroSpace's emulation: a native-Space filter may see many logical workspaces as one. That last interaction is an inference requiring a real test, not a documented compatibility promise.

### yabai: tile inside the native Spaces model

yabai's core is automatic binary-space-partitioning layout with a CLI for windows, Spaces, and displays; hotkeys can come from skhd or another dispatcher. Current requirements explicitly list Tahoe 26.0+ on Apple Silicon. Accessibility permission is required. Screen Recording is required **only if window animations are enabled**. Separate Spaces must be on. SIP changes are optional, and the README warns that unsigned/rebuilt binaries can lose permission continuity. [yabai README](https://github.com/asmvik/yabai#requirements-and-caveats).

The optional scripting addition is the exact boundary that matters. Current project documentation lists Space move/swap/create/destroy, shadow removal, transparency, window animations, scratchpads, layers, sticky windows, and arbitrary-window picture-in-picture among capabilities requiring partial SIP disablement. It describes injection into Dock.app; Apple Silicon also has an additional boot-argument requirement. This does **not** mean ordinary yabai tiling requires SIP disabled. Do not infer the status of an unlisted command from an old blog: inspect the chosen release's command implementation when specifying that operation. [Scripting-addition boundary](https://github.com/asmvik/yabai/wiki/Disabling-System-Integrity-Protection).

**Candidate experience:** keep Mission Control, native fullscreen, and Spaces as the organizing model while adding automatic layout and keyboard window manipulation. If advanced privileged features are actually needed, their precise benefit can be weighed separately. Enthusiast maintenance tolerance does not decide that security preference for Nick.

**Implementation obligations:** test ordinary tiling first with SIP unchanged; inventory which desired operations actually fail or require the scripting addition. Confirm each app's minimum size and transient-window behavior. If an addition is eventually chosen, its update/reload/recovery procedure belongs in the execution contract, including Dock restarts and OS updates. Do not treat a Nix boolean as proof that the system prerequisites have been met.

### Native windows and Raycast: a real candidate, not a fallback aesthetic

Apple supports tiling through window controls, dragging, menus, and keyboard commands. Native Spaces also support app assignment and movement of windows between desktops. These provide a useful baseline for deciding whether persistent automatic tiling improves the actual day. [Apple tiling guide](https://support.apple.com/guide/mac-help/tile-app-windows-mchlef287e5d/mac), [Apple Spaces guide](https://support.apple.com/guide/mac-help/work-in-multiple-spaces-mh14112/mac).

Raycast already provides focused-window resizing, halves/quarters, centering, restoring, movement to displays, and assignable hotkeys. Its manual also lists desktop/Space operations, but now spans platforms; do not assume every listed desktop command exists in the installed Mac build. Custom commands and additional features have plan-dependent boundaries. Its documented Stage Manager accommodation is another native-oriented route. [Raycast window management](https://manual.raycast.com/window-management).

**Candidate experience:** native Spaces and fullscreen remain familiar; a small key vocabulary lays out editor/browser/terminal, while appearance comes from coordinated app themes, wallpaper, typography, and optional borders/bar. This can look highly deliberate without a tiler. Its tradeoff is that project layout is explicitly invoked rather than continuously maintained.

**Proposal across all models:** one owner should control window geometry. Do not run AeroSpace and yabai together, or let Hammerspoon continuously resize windows that a tiler immediately rearranges. Keep Raycast arrangement commands only where their relationship to tiling/floating is intentional. This is an architectural recommendation derived from competing controllers, not a vendor incompatibility claim.

## The visible desktop: bar, borders, and native seams

### SketchyBar as a useful status surface

SketchyBar exposes bar height, position, color, blur, display selection, notch-related layout, and native-menu-bar interaction through a command interface. It is a programmable overlay, not a system-wide replacement for every app's menu or the macOS notification center. Retain a discoverable way to reach native menu commands when hiding the system bar. [Bar properties](https://felixkratz.github.io/SketchyBar/config/bar).

Its events include front-app changes, native Space changes, display changes, power changes, sleep, wake, and custom triggers. The docs recommend event subscriptions instead of polling where possible. They explicitly mark `wifi_change` nonworking since Sonoma and `media_change` deprecated on macOS 26.0. An attractive older bar configuration can therefore carry broken data sources even when the bar itself renders. [Events and scripting](https://felixkratz.github.io/SketchyBar/config/events).

**Proposed initial content:** project/workspace identity, focused app, agent attention count, and essential battery/time. This is a design hypothesis for later discussion. CPU graphs, network counters, music controls, and decorative animations need a reason to consume attention. Agent status needs an explicit producer and stable destination ID; reading terminal titles is insufficient proof that an agent is waiting for approval.

AeroSpace workspaces need its custom event integration; SketchyBar's native `space_change` event alone is not the right source of truth. Display/wake events are opportunities to reconcile state, not guarantees that every script has recovered. Avoid synchronous network calls in focus callbacks and initialize indicators when the bar starts. These are integration deductions from the documented event model.

The 2.24.1 release's notch, menu-height, display-recreation, and client-timeout fixes are practical evidence that these details evolve. They do not prove every dock or fullscreen issue is fixed on 26.5.1. [Release notes](https://github.com/FelixKratz/SketchyBar/releases/tag/v2.24.1).

### Borders as a focus cue

JankyBorders adds colored active/inactive borders on macOS 14+ and normally avoids Accessibility. It can run independently, from a tiler's startup, or via a service; a later invocation updates a running instance. Its config lives at `~/.config/borders/bordersrc`. These are window-outline overlays, not a mechanism for replacing arbitrary application titlebars. [JankyBorders README](https://github.com/FelixKratz/JankyBorders).

The manual includes widths, colors, rounded/square styling, filtering, HiDPI behavior, and an `ax_focus` mode; it says this mode is also enabled automatically if the parent process has Accessibility permission. Therefore “borders never uses Accessibility” is too broad. Test border tracking during fullscreen, quick-terminal appearance, app switching, and wake. [JankyBorders manual](https://github.com/FelixKratz/JankyBorders/wiki/Man-Page).

**Visual implication:** a restrained active-window cue can improve targeting without duplicating the terminal cursor, selection color, or agent-status colors. That role should be part of the impeccable concept work. “Everything glows” makes a convincing screenshot before it proves useful for hours of work.

### How far cohesive theming can go

| Surface | Supported control | Boundary to preserve |
|---|---|---|
| Ghostty | Theme files, palette, fonts, padding, light/dark theme selection | Per-app configuration, not an OS theme engine |
| VS Code | Workbench and syntax themes; color overrides; icon themes; OS light/dark detection | Extension UI and semantic token choices still need review |
| Raycast | Custom background/text/support colors through Themes | Documentation labels Themes Pro-exclusive; subscription is unknown |
| SketchyBar and borders | Direct palette, geometry, font and focus styling | Native menus, dialogs, notification UI remain separate |
| macOS and browser | Native appearance controls; Zen's project organization | Native appearance is narrower than arbitrary compositor CSS |

Sources: [Ghostty themes](https://ghostty.org/docs/features/theme), [VS Code themes](https://code.visualstudio.com/docs/configure/themes), [Raycast Themes](https://manual.raycast.com/themes), [Apple Appearance settings](https://support.apple.com/guide/mac-help/change-appearance-settings-mchlp1225/mac). Bar/border controls are sourced above.

**Proposed theme architecture:** one small semantic palette—background, foreground, subdued text, selection, focus, warning, error—plus type roles and spacing values. Generate each supported app's syntax from it, and document the surfaces that remain native. Keep runtime theme selection separate from immutable generated assets. An app-specific import may remain manual. This avoids pretending there is a universal macOS equivalent to a Linux compositor/theme stack.

Impeccable can help compare visual hierarchy, density, contrast, focus signaling, typography, and motion in realistic desktop concepts. The prototypes should show code, an agent waiting for input, browser content, multiple windows, and a native dialog. A wallpaper alone cannot answer whether the workspace is legible. This is proposed later decision work; no visual direction has been selected.

## Movement between applications, projects, and terminal sessions

### Retain Raycast's discovery role and make ownership explicit

Raycast Script Commands expose local scripts as searchable commands and global hotkeys. The manual explains their working-directory behavior and that permissions belong to the calling Raycast app rather than Terminal when Raycast runs the script. This is an appropriate entry point for “open project,” “return to agent,” and “apply selected theme,” if those workflows are accepted. Scripts should be repeatable without creating duplicate sessions or windows. [Script Commands](https://manual.raycast.com/script-commands).

Raycast now also documents a Hyper Key feature, including a quick press that can send Escape. Its optional Secure Input compatibility reserves Right Control and only supports Raycast Hyper shortcuts while Secure Input is active. Investigate the installed build before adding Karabiner solely for a Hyper key; a separate remapper needs a concrete missing behavior, such as more elaborate per-device rules. Chosen modifiers must avoid editor chords, terminal Meta keys, native input shortcuts, and AltTab. [Raycast Hyper Key](https://manual.raycast.com/hyper-key).

For example, AeroSpace's sample maps Alt-Tab to workspace-back-and-forth while an existing AltTab setup may own the same chord. The eventual key map should separate app switching, window switching, workspace switching, and terminal-pane switching. A shared directional vocabulary can be useful, but silently overloading every layer makes target prediction harder. [AeroSpace default configuration](https://nikitabobko.github.io/AeroSpace/guide#default-config).

AltTab supplies window switching rather than tiling. In its v11.9.1 source, Accessibility is a core permission while Screen Recording supports the thumbnails and selected-window preview; titles/app-icons modes need no screenshots. Thus screen capture access is a feature-dependent choice, not an unconditional requirement for all AltTab use. Existing installed permissions were not inspected. [Permission implementation](https://github.com/lwouis/alt-tab-macos/blob/v11.9.1/src/macos/SystemPermissions.swift), [Feature-specific permission specification](https://github.com/lwouis/alt-tab-macos/blob/v11.9.1/src/macos/PermissionCalloutResolverSpecs.md).

### Existing Ghostty already contains consequential workflow tools

Ghostty shell integration can inherit working directories into new terminals, mark prompts for navigation, select a command's output, and improve prompt redraw. zsh receives automatic injection. A blank user config does not imply these defaults are absent. [Shell integration](https://ghostty.org/docs/features/shell-integration).

Ghostty 1.3 added AppleScript control over windows, tabs, and terminal panes, with working-directory information and creation/focus/input operations. This makes a project command substantially more precise than simulated keystrokes. The installed scripting dictionary is the source of truth for exact operations. Avoid “send command to whatever terminal is focused” as the foundation of an agent workflow. [Ghostty AppleScript](https://ghostty.org/docs/features/applescript).

A quick terminal provides a persistent-on-hide scratch surface behind a global keybinding. There is one instance; macOS quick-terminal tabs are unsupported, and it is not restored across application restart. This is useful for brief commands, not a replacement for durable multi-project sessions. [Quick-terminal action and limitations](https://ghostty.org/docs/config/keybind/reference#toggle_quick_terminal).

Current config docs also expose quick-terminal monitor/Space behavior, command-finished notifications with a duration threshold, and font/background controls. Command-finished notification defaults are off and require shell integration or OSC 133 markers. Background images are duplicated per terminal in VRAM; decorative effects therefore have real costs to measure. [Configuration reference](https://ghostty.org/docs/config/reference).

**Proposed distinction:** process exit, agent turn finished, and agent awaiting human input are separate states. A shell-completion notification cannot detect an interactive agent waiting in a still-running process. Agent-native events should feed a status bar or notification workflow only after the separate AI investigation establishes reliable hooks. Keep navigation possible even if the status producer fails.

### Multiplexing adds a different form of durability

| Session owner | Useful when | Cost or limitation |
|---|---|---|
| Ghostty windows/tabs/splits | Local work benefits most from native text, window, and scripting behavior | A visible terminal layout is not persistence of arbitrary running processes |
| tmux inside Ghostty | Detach/reattach, remote work, long-running jobs, scriptable named sessions matter | Adds its own prefix, pane tree, clipboard and terminal-protocol layer |
| Zellij inside Ghostty | Discoverable session management and serialized layout reconstruction matter | Reconstructed commands are reruns, not restored process memory; cache/scrollback behavior needs a policy |

tmux explicitly supports detaching and reattaching programs, including through remote connection loss. It does not make a local process survive host reboot. [tmux getting started](https://github.com/tmux/tmux/wiki/Getting-Started). Zellij serializes layouts and commands, can retain viewport/scrollback, and normally gates resurrected commands behind Enter rather than immediately rerunning them. Its documentation also notes command discovery can be inaccurate for wrappers. [Zellij resurrection](https://zellij.dev/documentation/session-resurrection).

**Proposal:** choose which layer owns terminal panes. Desktop tiling + Ghostty splits + tmux splits + an agent orchestrator can create four independent spatial models. Multiplexing is justified by a persistence or remote-access need; it is not a prerequisite for an attractive desktop. A project identifier can connect the layers without making them all imitate one another.

Zen already offers browser workspaces and optional default containers. Containers separate cookie sessions but not browsing history or extensions. A browser workspace is not a macOS workspace; opening a new browser window does not by itself establish a separate project identity. [Zen workspaces](https://docs.zen-browser.app/user-manual/workspaces).

**Open integration question:** should a project mean a desktop workspace with separate browser/editor windows, or a terminal/agent session plus a shared browser whose internal workspace is selected? That choice affects duplicate windows, login state, and the number of shortcuts. Confirm available Zen automation before promising a fully synchronized switch.

## Automation, notifications, capture, and small conveniences

Hammerspoon is a Lua bridge to macOS APIs: windows, apps, audio, screens, keyboard/mouse events, clipboard and more. It intentionally does nothing until configured. Its strongest potential role here is specific missing glue, rather than another general controller installed in advance. [Hammerspoon overview](https://www.hammerspoon.org/).

Its screen watcher detects display-configuration changes; its caffeinate watcher exposes sleep, wake, lock, unlock and session events. These can drive a docked/laptop layout or recovery action. A watcher is a trigger, not a guarantee that displays and apps are immediately ready; any proposed reconciler should debounce and be idempotent. [Screen watcher](https://www.hammerspoon.org/docs/hs.screen.watcher.html), [Sleep/wake watcher](https://www.hammerspoon.org/docs/hs.caffeinate.watcher.html).

Hammerspoon's `hs.spaces` is explicitly experimental, uses private APIs and Accessibility interaction with Mission Control, and cannot fully suppress visible transitions for certain actions. It is not a way to obtain every native Space operation with the reliability of a public API. [Spaces API caveats](https://www.hammerspoon.org/docs/hs.spaces.html).

Apple Shortcuts has a supported CLI, including running a named shortcut with input/output. It can remain the owner of a macOS-native automation while Raycast or a script launches it. This is a useful boundary for actions better expressed in app integrations than raw window events. [Shortcuts command line](https://support.apple.com/guide/shortcuts-mac/run-shortcuts-from-the-command-line-apd455c82f02/mac).

Raycast's existing clipboard history can cover text/image/file recall and application exclusions. Its current documentation includes disabled applications for sensitive clipboard sources. Review the user's actual exclusions and retention before extending capture flows; do not add a second history daemon without a missing capability. [Clipboard History](https://manual.raycast.com/clipboard-history).

Native Screenshot covers selection/window/screen capture and screen recording, destination choices and capture options. This gives an immediate baseline for screenshots-to-clipboard and attaching evidence to an agent or issue. Evaluate a dedicated capture app later only for a concrete requirement such as recurring annotation or polished video output. [Apple screenshot and recording guide](https://support.apple.com/guide/mac-help/take-a-screenshot-mh26782/mac).

Native notification settings control app permissions, previews, and alert behavior. A notification producer should be evaluated under the user's Focus and lock-screen preferences; sending an event is not proof it will interrupt the user. Propose a quiet durable “needs attention” indicator plus an explicit return action, with urgency reserved for chosen events. [Apple notification settings](https://support.apple.com/guide/mac-help/change-notifications-settings-mh40583/mac).

## Permissions and operating-system boundaries

| Capability | Permission or mechanism | Planning consequence |
|---|---|---|
| AeroSpace/yabai window manipulation | Accessibility; AeroSpace needs no SIP reduction; ordinary yabai tiling has an optional addition boundary | Grant to the actual installed binary/app; verify after packaging changes |
| yabai animation and advanced window/Space features | Screen Recording for animation; partial SIP changes for documented scripting-addition features | Separate basic tiling from the advanced feature decision |
| AltTab previews | Accessibility plus Screen Recording when screenshots are used | Titles/icons can avoid capture; inspect chosen appearance |
| App scripting/capture | Automation for app-to-app control; Screen & System Audio Recording as applicable | Permission depends on caller and action; launching through Raycast changes the caller |
| Borders/bar/glue | JankyBorders defaults avoid AX; optional focus mode differs; individual scripts can need additional rights | Do not grant a generic “ricing permissions bundle” |

Apple documents user-controlled Accessibility and screen/audio recording approvals in Privacy & Security. Those approvals are separate from package installation and dotfile generation. For this personal, unmanaged plan, retain manual permission onboarding instead of promising that a Nix rebuild grants everything. [Apple Accessibility](https://support.apple.com/guide/mac-help/allow-accessibility-apps-to-access-your-mac-mh43185/mac), [Apple recording access](https://support.apple.com/guide/mac-help/control-access-to-screen-and-system-audio-recording-mchld6aa7d23/mac). Tool-specific distinctions are supported in the sections above.

No component here is a replacement macOS compositor. Native app titlebars, window-server rules, fullscreen Spaces, protected dialogs, TCC, and application minimum sizes remain constraints. Matching the feel of a cohesive Linux desktop is feasible through coordinated behavior and themeable surfaces; exact visual/control parity is not established by these tools.

## Configuration ownership grounded in this repository

The inspected lock pins nixpkgs to `55afc4c3adc7194df3b96d43b7d18bf8131bfcfa`, nix-darwin to `c3e90c89649b07d1a96e4b9dd6cd0d6e44b91a74`, and Home Manager to `db7d5e2332710f5abb088f6b5de927d7f9511b35`. Prefer these exact sources over a search result from an unstable manual. The live nix-darwin manual inspected identifies itself as 26.11, while this repo selects 26.05 branches. [Repository lock](https://github.com/NickSeagull/dotfiles/blob/5c1f438b02209fb18c6e275215b60e212056e55d/flake.lock), [live manual](https://nix-darwin.github.io/nix-darwin/manual/).

### Package evidence at the pin

| Package expression | Version / platform evidence | Implication |
|---|---|---|
| [aerospace](https://github.com/NixOS/nixpkgs/blob/55afc4c3adc7194df3b96d43b7d18bf8131bfcfa/pkgs/by-name/ae/aerospace/package.nix) | 0.20.3-Beta, Darwin | Behind inspected upstream 0.21.3-Beta; validate config syntax against the actual package |
| [yabai](https://github.com/NixOS/nixpkgs/blob/55afc4c3adc7194df3b96d43b7d18bf8131bfcfa/pkgs/by-name/ya/yabai/package.nix) | 7.1.25; prebuilt binary on aarch64-darwin | Nix availability does not require compiling the Apple Silicon executable locally |
| [sketchybar](https://github.com/NixOS/nixpkgs/blob/55afc4c3adc7194df3b96d43b7d18bf8131bfcfa/pkgs/by-name/sk/sketchybar/package.nix) | 2.23.0, Darwin | Does not include every fix named in 2.24.1 release notes |
| [jankyborders](https://github.com/NixOS/nixpkgs/blob/55afc4c3adc7194df3b96d43b7d18bf8131bfcfa/pkgs/by-name/ja/jankyborders/package.nix) | 1.9.0, Darwin | Package attribute differs from executable `borders` |
| [ghostty-bin](https://github.com/NixOS/nixpkgs/blob/55afc4c3adc7194df3b96d43b7d18bf8131bfcfa/pkgs/by-name/gh/ghostty-bin/package.nix) | 1.3.1, Darwin; official DMG | Existing app can remain externally installed, or this package can explicitly own it |
| [ghostty source expression](https://github.com/NixOS/nixpkgs/blob/55afc4c3adc7194df3b96d43b7d18bf8131bfcfa/pkgs/by-name/gh/ghostty/package.nix) | 1.3.1, Linux metadata | Do not blindly copy a Linux package example; evaluate final attribute/platform choice |
| [tmux](https://github.com/NixOS/nixpkgs/blob/55afc4c3adc7194df3b96d43b7d18bf8131bfcfa/pkgs/by-name/tm/tmux/package.nix) | 3.6a, Unix with Darwin-specific handling | Plausible declarative CLI package, still requires build/evaluation verification |

These are source inspections, not successful derivation builds or cache-availability checks. Zellij's package delegates to another expression; its current version was not resolved. Hammerspoon packaging was not established from the guessed by-name path, so no Nix availability claim is made for it.

### Modules already available

Pinned nix-darwin includes `services.aerospace`, `services.yabai`, `services.sketchybar`, and `services.jankyborders`, with launchd ownership. The AeroSpace module disables app-managed login startup; yabai's scripting addition defaults off and enabling it also creates privileged loading/sudo configuration. SketchyBar accepts explicit extra packages for its service PATH. [AeroSpace module](https://github.com/nix-darwin/nix-darwin/blob/c3e90c89649b07d1a96e4b9dd6cd0d6e44b91a74/modules/services/aerospace/default.nix), [yabai module](https://github.com/nix-darwin/nix-darwin/blob/c3e90c89649b07d1a96e4b9dd6cd0d6e44b91a74/modules/services/yabai/default.nix), [SketchyBar module](https://github.com/nix-darwin/nix-darwin/blob/c3e90c89649b07d1a96e4b9dd6cd0d6e44b91a74/modules/services/sketchybar/default.nix), [borders module](https://github.com/nix-darwin/nix-darwin/blob/c3e90c89649b07d1a96e4b9dd6cd0d6e44b91a74/modules/services/jankyborders/default.nix).

Pinned Home Manager also includes AeroSpace and SketchyBar modules. Its AeroSpace settings use a TOML format; the Darwin module has a more structured `on-window-detected.if` schema. Current upstream documentation shows newer expression-based conditions, so changing only the binary can expose a module/schema mismatch. Pick a compatible module/config path as part of version selection. Home Manager SketchyBar supports Bash/Lua configuration, dependencies, and a service. [Home Manager AeroSpace](https://github.com/nix-community/home-manager/blob/db7d5e2332710f5abb088f6b5de927d7f9511b35/modules/programs/aerospace.nix), [Home Manager SketchyBar](https://github.com/nix-community/home-manager/blob/db7d5e2332710f5abb088f6b5de927d7f9511b35/modules/programs/sketchybar.nix).

Home Manager's Ghostty module supports `package = null`, generated settings and themes, and a Darwin-compatible XDG config path. That allows the existing native app to stay app/Homebrew-managed while Nix manages text configuration. Its automatic validation hook is conditional on having a package, so `package = null` requires a separate installed-binary validation step. Alternatively specify the Darwin binary package explicitly after evaluation. [Pinned Ghostty module](https://github.com/nix-community/home-manager/blob/db7d5e2332710f5abb088f6b5de927d7f9511b35/modules/programs/ghostty.nix).

### A feasible division of responsibility, subject to agreement

| Owner | Candidate responsibility | Exclude from that owner |
|---|---|---|
| Determinate | Nix installation, daemon and Nix configuration as already declared | A competing nix-darwin Nix daemon |
| nix-darwin | Agreed system defaults, fonts/packages, one launchd service owner, optional Homebrew declarations | Runtime agent state and user-granted TCC approvals |
| Home Manager | User shell tools, generated config/themes, launcher scripts; user services if chosen instead of Darwin services | Immutable replacements for mutable app databases |
| Homebrew or app updater | Native GUI apps where preferred for signing/update lifecycle | A second copy of the same app already owned by Nix |
| App/manual state | Accounts, licenses, approved permissions, mutable preferences/history, selective export backups | Secrets or full browser/app databases committed to dotfiles |

This is a proposed ownership model, not an accepted partition. Enabling equivalent Darwin and Home Manager services simultaneously, plus `brew services` or app login startup, would undermine it. Specify one install owner and one startup owner per component. Generated scripts should use declared executable paths or explicit PATH rather than assuming a GUI inherits an interactive shell environment.

nix-darwin can declare Homebrew taps, formulae/casks and activation policies. Homebrew Bundle can describe installation intent, but its docs distinguish that from a lockfile with fully reproducible versions. A Nix-managed Brewfile does not turn upstream mutable casks into pinned derivations. Keep auto-upgrade/cleanup policy explicit and preserve existing applications when introducing ownership. [Pinned Homebrew module](https://github.com/nix-darwin/nix-darwin/blob/c3e90c89649b07d1a96e4b9dd6cd0d6e44b91a74/modules/homebrew.nix), [Homebrew Bundle](https://docs.brew.sh/Brew-Bundle-and-Brewfile).

Raycast documents export/import of settings, extensions and data. Treat export as app-owned backup/migration material, not necessarily a small declarative config suitable for a public repository. Review contents and credentials before deciding what to retain. [Raycast import/export](https://manual.raycast.com/import-export).

## Three candidate architectures to react to

| Architecture | Daily behavior | Likely components | Main question |
|---|---|---|---|
| **Project workspaces** | Fast named contexts, directional focus, predictable “return to project” | AeroSpace; existing Raycast/Ghostty; optional borders and custom-event SketchyBar | Can emulated workspaces replace native Spaces/fullscreen in Nick's actual monitor setup? |
| **Native Spaces with automatic layout** | Keep native desktops/fullscreen while tiling ordinary windows | yabai without scripting addition initially; chosen hotkey dispatcher; optional bar/borders | Do desired operations fit the non-addition feature set? If not, is the exact advanced feature worth its boundary? |
| **Native navigation with deliberate layouts** | Keep gestures/Spaces; invoke arrangements and project actions | Existing Raycast/AltTab/Ghostty; app themes; optional borders; targeted Hammerspoon only if needed | Is automatic tiling actually helpful, or is context recovery the missing convenience? |

These are alternatives for behavior, not tiers of seriousness. All can share a theme vocabulary, project naming, an agent-attention model and launcher scripts. None requires replacing the editor or browser just to resemble Omarchy. Agent-orchestration product choices belong to the sibling research and later human decision.

## Verification obligations for the eventual implementation task

The following are **proposed acceptance checks**, not executed tests or promises of compatibility.

1. **Prove the navigation model with real work.** Open two projects with editor, browser and terminal/agent windows; switch repeatedly by the intended keys and launcher; verify the target, window title, browser context, and working directory. Include a new dialog and a permission prompt. Record what “return to project” means.
2. **Exercise laptop and display transitions.** Test built-in display, actual external-monitor arrangement, disconnect/reconnect, clamshell if used, lock/unlock and sleep/wake. Check focus, hidden windows, bar/border placement and menu access. Test native video fullscreen while using the other monitor; record separate-Spaces setting.
3. **Prove attention and capture flows.** Trigger a long command completion, an actual agent approval wait, failure and success. Confirm notification routing and a precise return action under normal Focus settings. Capture a selected region to the chosen destination and paste it into the real workflow.
4. **Measure idle and busy cost.** Compare before/after CPU, memory, wakeups/energy over a defined 10-minute idle window and a representative active session. Test on battery. Investigate frequent polling, growing subprocess counts, animated effects and decorative terminal backgrounds before adding more widgets.
5. **Prove recovery and ownership.** Rebuild/evaluate the selected Nix configuration before activation; inspect generated settings with the installed tool version; verify only one service/app copy starts. Stop the custom layer and recover visible windows. Restore the previous configuration and app-owned backup without closing live jobs unnecessarily. Recheck permissions after a controlled update.

Exact commands should be confirmed against the final selected versions and repository workflow. This research did not run `darwin-rebuild`, build packages, change defaults, grant permissions, restart Dock, or alter SIP. A Nix rollback restores its managed configuration/package references; the plan must separately account for app database changes, Homebrew updates, TCC grants and any manual OS setting.

## Human decisions this report leaves open

1. **Workspace identity:** project, app role, or current activity? What should one shortcut restore: windows, browser workspace, terminal session, or all of them?
2. **Display and fullscreen contract:** actual monitors/docking habits; whether native fullscreen and trackpad Spaces remain central; which tradeoff to prototype first.
3. **Session and attention contract:** durable local/remote terminal sessions, number of parallel agents, meaningful ready/waiting states, and what must survive app exit versus reboot.
4. **Visual direction:** density, light/dark preference, typography, native chrome, bar content, focus cue, and whether paid Raycast theme support is acceptable.
5. **Ownership and rollout:** native app updates versus pinned packages, configuration source, one service owner, exact permission boundaries, and checkpoints for a reversible rollout.

The next bounded action is to answer the first question with one real working example: **“When I switch from project A to project B, I want these windows and sessions in front of me.”** That answer can drive the workspace decision before any installation.
