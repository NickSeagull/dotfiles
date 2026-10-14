# Omarchy beyond the package list: integrated experiences worth studying

**Research answer:** Omarchy's distinctive value is a maintained set of agreements between desktop components: how to launch something, where it opens, how it looks, how to discover its controls, and how to recover when it changes. For an experienced ricer, most ingredients are familiar. The interesting product is the accumulation of small, finished workflows and the fact that somebody else maintains their seams.

Prepared on **2026-10-14** for [Understand Omarchy’s integrated experience and appeal](https://plane.p.egregore.io/egregore/projects/e4709aa7-c911-4a7b-a9ec-f9eaa2bb905b/issues/17568c73-706e-4435-b56c-623cce4357d6/), part of **Shape a distinctive macOS daily driver inspired by Omarchy**. This is research, not a decision to adopt a stack or change the Mac. No Omarchy software was installed or run; findings come from source inspection, official documentation, and attributed first-person accounts.

## 1. Establish the version before discussing the goodies

There are three materially different Omarchies in search results. Mixing them produces a misleading shopping list.

| Evidence layer | What was verified | How this report uses it |
|---|---|---|
| Legacy v3 | The old manual explicitly redirects readers to the Quattro manual. Its Walker/Waybar/Mako/Hyprlock descriptions are historical. | Historical context only. |
| Released Quattro | GitHub marked **v4.0.4** latest; release page says September 15. Fetched tag resolves to **`c668141e9c42b13c80c9ca4ea108e11708c5e8a5`**. | **Released** means present in inspected release source or explicitly announced in v4 release notes. |
| Moving Quattro source | Default checkout **`84cfb93959f4fe0bbb71de71593b36647d2ba78d`**, commit dated October 14, 2026, “Omarchy in 50 languages.” | **Current-source** means observed here, without assuming it has reached stable packages. |
| Live website manual | Retrieved during this investigation; already describes features absent from the release tag. | Current documentation, cross-checked against code where important. |

Sources: [legacy manual](https://learn.omacom.io/2/the-omarchy-manual), [v4.0.4 release](https://github.com/omacom/omarchy/releases/tag/v4.0.4), [release commit](https://github.com/omacom/omarchy/commit/c668141e9c42b13c80c9ca4ea108e11708c5e8a5), [examined checkout](https://github.com/omacom/omarchy/commit/84cfb93959f4fe0bbb71de71593b36647d2ba78d).

**The big architectural change is already released.** Quattro replaced the separate bar, launcher, menus, notification daemon, OSDs, lock screen and several control utilities with a Quickshell desktop. Hyprland still manages windows. Omarchy also moved its internals from a mutable checkout into Arch packages, with user configuration kept separately. Thus “copy Omarchy's Waybar config” misses the current design. [Quattro release announcement](https://github.com/omacom/omarchy/releases/tag/v4.0.0)

A concrete example of documentation drift: the live screenshot manual describes **Omasnap**, but the inspected stable release uses **grim plus Tensaku**. Both implement a capture workflow; they are not the same feature set. Similarly, Foot—not Ghostty—is in the release's base package list. Ghostty remains a supported choice. [Released capture script](https://github.com/omacom/omarchy/blob/c668141e9c42b13c80c9ca4ea108e11708c5e8a5/bin/omarchy-capture-screenshot), [released base packages](https://github.com/omacom/omarchy/blob/c668141e9c42b13c80c9ca4ea108e11708c5e8a5/install/omarchy-base.packages), [current capture wrapper](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/bin/omarchy-capture-screenshot)

## 2. The desktop has a shared command vocabulary

**Released:** `Super+Space` searches applications and system actions together. The apps-only surface is `Super+Alt+Space`. Nested settings are searchable without knowing which submenu contains them. This makes “change theme,” “start recording,” “open browser,” and “install an editor” variations of one interaction. [Quattro announcement](https://github.com/omacom/omarchy/releases/tag/v4.0.0)

**Current-source implementation:** menu entries are declarative data with labels, descriptions, actions and visibility conditions. User entries overlay defaults by ID. A customization can replace one label or command without copying the whole menu. Edits are watched live. The same shell supplies selection and text-input dialogs to scripts, so a personal utility can inherit the desktop's interaction and appearance. There is a limitation: the JSONC parser accepts whole-line comments, not arbitrary inline comments; malformed user JSON contributes no user entries. [Menu contract](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/docs/menu.md)

**Discovery is part of the setup.** Learn entries lead to Omarchy, Hyprland, Arch, editor and shell references. The keybinding browser examines configured bindings rather than presenting only a static wallpaper cheat sheet. First login supplies a clickable keybinding notification. Config entries launch the chosen editor and arrange the necessary reload afterward. [Menu definitions](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/default/omarchy/omarchy-menu.jsonc), [binding browser](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/bin/omarchy-menu-keybindings), [first-run behavior](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/docs/file-layout.md), [configuration manual](https://omarchy.org/manual/dotfiles/)

**Interpretation for Nick:** the valuable thing to reproduce is a personal command surface that stays aligned with actual configuration. Raycast is already installed; buying or replacing a launcher is not inherently the missing work. The later decision should specify which desktop actions deserve names, hotkeys, visible state and discoverable documentation.

## 3. Windows support several scales of attention

The release's bindings support a coherent progression from individual windows to workspaces and grouped tasks. [Pinned released tiling bindings](https://github.com/omacom/omarchy/blob/c668141e9c42b13c80c9ca4ea108e11708c5e8a5/default/hypr/bindings/tiling.lua)

| Experience | Concrete flow | Why it matters |
|---|---|---|
| Spatial navigation | Open terminal and browser; focus with Super+arrows; swap them with an added Shift; change split orientation with Super+J. | The same directions mean focus or rearrangement depending on modifier. |
| Workspace allocation | Super+number selects a workspace; Shift moves a window there; Shift+Alt moves it without following. Entire workspaces can move between monitors. | Supports deliberate separation of active work and background work. |
| Dwindle or scrolling | Toggle a workspace's layout with Super+L; current implementation remembers layout choice per workspace. | A dashboard can keep everything visible while a coding workspace preserves readable window widths. |
| Groups and scratchpad | Group windows with Super+G; cycle within the group. Summon a separate scratchpad with Super+S. | Related apps can occupy one tile; a transient utility need not displace the working arrangement. |
| Pinned and enlarged windows | Super+O floats and pins a window across workspaces; separate shortcuts provide fullscreen and maximized-with-bar modes. | A call, video or reference can remain visible without becoming the main workspace. |

Persistence of per-workspace layout is documented and implemented separately from terminal persistence. Do not read the phrase “layout restoring” as proof of complete project/session resurrection: the examined window-width helper stores a width keyed by application and workspace; it does not recreate applications, browser tabs or processes. [Navigation manual](https://omarchy.org/manual/navigation/), [workspace layout source](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/default/hypr/workspace-layouts.lua), [width save/restore implementation](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/bin/omarchy-hyprland-window-width)

**Interpretation:** these are established tiling ideas, not inventions unique to Omarchy. Their value is that scratchpad, pinning, grouping, fullscreen variants, scrolling and workspace movement already agree on a key vocabulary. For a 15-year ricer, the decision is which of these genuinely supports today's code/browser/agent loop—not whether tiling is novel.

## 4. Theme changes are a cross-application operation

**Released:** the tag contains 22 theme directories, including light themes, familiar palettes such as Gruvbox and Tokyo Night, and more distinctive options such as Lumon and Retro 82. A theme selection changes more than the wallpaper. The release's theme script builds a staged active theme, changes the shell/background, and invokes retint or reload helpers for terminals, Hyprland, btop, tmux, GTK, browser, editors, Obsidian and several agent interfaces. [Released themes](https://github.com/omacom/omarchy/tree/c668141e9c42b13c80c9ca4ea108e11708c5e8a5/themes), [released activation script](https://github.com/omacom/omarchy/blob/c668141e9c42b13c80c9ca4ea108e11708c5e8a5/bin/omarchy-theme-set)

**Current-source design:** `colors.toml` is the palette input; templates produce application configurations. Semantic roles include accent, selection, muted text and multiple background/foreground levels, alongside terminal colors. The shell also has tokens for spacing, typography, border widths, control states and individual surfaces. User templates take priority over defaults. This is a small design system and a set of adapters, rather than a directory of unrelated copied themes. [Theming contract](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/docs/theming.md)

The current pipeline retints visible terminal surfaces before slower secondary apps. It logs failures and can notify about them. That qualification matters: choosing a theme is not a guarantee every application updates synchronously or successfully. Obsidian requires selecting the Omarchy theme inside the app. A user-written theme can override application-specific files; installed Git themes filter files capable of executing code and regenerate those from the palette. [Current theme activation](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/bin/omarchy-theme-set), [theme manual](https://omarchy.org/manual/themes/), [custom theme manual](https://omarchy.org/manual/making-your-own-theme/)

Typography gets similar treatment: JetBrainsMono Nerd Font is the default monospace face; the font command updates terminal settings and fontconfig so the shell and other monospace consumers follow. Running terminals may need restarting. Font families and sizes are not magically universal across every independent application. [Fonts manual](https://omarchy.org/manual/fonts/), [font propagation code](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/bin/omarchy-font-set)

**Optional creativity on a bundled foundation:** Aether is included and provides a GUI for creating themes, including extracting a palette from a background. Personal backgrounds and externally installed theme repositories are additions, not all shipped content. [Aether and custom-theme guidance](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/manual/43-making-your-own-theme.md)

**Implication for impeccable:** compare desktop concepts through semantic color roles, typography, density, focus indication and motion. Then define which Mac surfaces consume those roles. A cool screenshot is insufficient if the browser, editor and launcher drift apart during daily use. Conversely, matching every native macOS surface may cost more than the visual gain; that boundary belongs in the later visual decision.

## 5. Small utilities share the desktop's state and feedback

The current bar does more than show shell-command output. Audio has device selection and an app mixer; display controls expose brightness and scaling; power settings distinguish battery and AC preferences. Keyboard access opens the same panels. Active-mode indicators cover recording, reminders, dictation, DND and staying awake. Some bundled widgets are disabled by default; service panels such as Tailscale and Dropbox appear after the relevant optional installation. [Top bar manual](https://omarchy.org/manual/the-top-bar/)

The relevant design principle is **state that remains visible after a shortcut changes it**. “Keep awake” without an indicator is easy to forget. Omarchy's toggles connect a shortcut, menu action, command and indicator to one state. Current idle defaults are 150 seconds to screensaver and 300 seconds to lock, measured from last activity. These are choices to evaluate, not settings to copy onto Nick's Mac. [Toggle behavior](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/manual/13-toggles-idle-screensaver.md), [default shell configuration](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/config/omarchy/shell.json)

Notifications retain useful continuity. Current code persists visible popups across shell restarts and retains the latest ten history entries, including relevant notifications silenced by DND. Hover pauses expiry; critical notifications persist; clicking can return to an application or perform a defined action. DND has exceptions for confirmations of the user's own actions and particular critical CLI alerts. This is not a permanent notification archive. [Notification implementation contract](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/docs/notifications.md)

Countdown reminders are built in: a short command or menu prompt queues a message, with actions to inspect or clear pending reminders. They are deliberately small, not a replacement for a task manager. [Reminder manual](https://omarchy.org/manual/reminders/)

**Interpretation for the Mac:** the promising benefit is reduced ambiguity—know whether a mode is active and where to return after an interruption. Replacing all native notifications or adding every status widget is not necessary to achieve that.

## 6. Capture becomes something you can immediately use

**Released capture flow:** choose a region/window/monitor against a frozen view, save the image and copy it to the clipboard, then click the resulting notification to open Tensaku for editing. The script explicitly treats notification failure as separate from successful capture. This is the kind of edge handling hidden behind “includes screenshot tooling.” [Released screenshot implementation](https://github.com/omacom/omarchy/blob/c668141e9c42b13c80c9ca4ea108e11708c5e8a5/bin/omarchy-capture-screenshot)

**Current-source capture flow:** Omasnap provides the overlay, region/window/full-screen and scrolling capture, a preview that can stay pinned, and an annotation editor. Its documented tools include arrows, text, numbered markers, redactions, cropping, cut-outs and OCR. Recording offers audio-source choices and an optional webcam overlay, then exposes recording state in the bar. These current manual capabilities should not all be attributed to v4.0.4. [Current capture manual](https://omarchy.org/manual/screenshots-recording/), [current package inventory](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/install/omarchy-base.packages)

Two smaller paths are particularly practical. Region OCR captures pixels, runs Tesseract and puts recognized text on the clipboard. The transcode action offers common image/video formats and sizes, writes a new output and places its file URI on the clipboard for sharing. These turn low-level tools into repeatable desktop actions. [OCR code](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/bin/omarchy-capture-text), [transcode code](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/bin/omarchy-transcode)

LocalSend is bundled. Omarchy adds a share menu for clipboard text, files and folders, plus a Nautilus context-menu path. The clipboard action creates a temporary text file; it is not a universal cross-device clipboard synchronization service. [Share wrapper](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/bin/omarchy-menu-share), [Nautilus integration](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/default/nautilus-python/extensions/localsend.py)

**Candidate flow for Nick, not an adoption decision:** capture a browser defect → annotate it → attach it to the relevant agent or issue → return to the same code context. The target is fewer handoffs and less file hunting. Exact Mac tools belong to the companion macOS research.

## 7. Clipboard, browser and terminal conventions bridge app boundaries

Unified `Super+C/X/V` avoids changing copy/paste habits between GUI apps and terminals. The compositor detects terminal windows and sends the appropriate modified shortcut. Clipboard history supports text and images. There are still exceptions: agent harnesses commonly use Ctrl+V for image input while ordinary paste is text. This is documented as “almost everywhere,” not universal compatibility. [Clipboard manual](https://omarchy.org/manual/unified-clipboard-history/), [shortcut dispatch code](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/default/hypr/bindings/clipboard.lua)

Web apps are desktop entries with named, frameless browser windows. Installation asks for a name, URL and icon; a launch-or-focus helper can target an existing window. The current browser wrapper uses supported Chromium-family browsers and otherwise falls back to Chromium. A preferred Firefox-family browser does not automatically mean its web apps use that engine. Authentication also has a seam: the manual recommends logging in through the normal browser first because the thin app frame does not work well with 1Password. [Web app manual](https://omarchy.org/manual/web-apps/), [browser selection wrapper](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/bin/omarchy-launch-webapp), [focus-or-launch wrapper](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/bin/omarchy-launch-or-focus-webapp)

The default web-app set reflects the authors' preferences, including HEY and Basecamp. A shortcut is not a bundled subscription. For Nick, the useful question is whether an important web service deserves a stable window identity and workspace role rather than another browser tab.

Terminal launch preserves context: the current launcher resolves the active terminal's directory and opens the selected terminal there. The file-manager shortcut can similarly open the current terminal directory. An arbitrary TUI can be registered as an app with its own name, command, icon and window treatment. This makes a resource monitor or project tool feel like a desktop application. [Terminal launcher](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/bin/omarchy-launch-terminal), [GUI manual](https://omarchy.org/manual/guis/), [TUI manual](https://omarchy.org/manual/tuis/)

**Mac relevance:** consistent Command copy/paste, previews, familiar launcher usage and native utility apps may already cover much of this. Do not count recreating existing behavior as an improvement. Context-preserving launch and named project entry points are the more interesting gaps to test.

## 8. Development comes with conventions, not only binaries

Omarchy includes a LazyVim-based Neovim setup in `omarchy-nvim`; a default-editor abstraction and optional editor installers avoid making Neovim mandatory. Language environments are largely provisioned with Mise. Docker and Compose have an installation/configuration path, with database setup available through the development menu. Current documentation says Docker requires authorization by default; the convenience of adding the user to the Docker group is an explicit optional choice. [Editor manual](https://omarchy.org/manual/neovim/), [development manual](https://omarchy.org/manual/development-tools/)

Tmux is configured for resumable sessions with `Ctrl+Space` as prefix. A launcher attaches to a running session or creates `Work`. Supplied layout functions build an editor/agent/terminal arrangement, a four-pane arrangement with a live diff, one arrangement per subdirectory, or a command grid. **These are launch recipes, not proof of job orchestration, isolation or automatic recovery after reboot.** [Terminal manual](https://omarchy.org/manual/terminal/), [session launcher](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/bin/omarchy-launch-terminal-tmux), [layout implementation](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/default/bash/fns/tmux)

Current shell functions also wrap worktree creation/removal, rsync watchers, SSH port forwards and reconnecting interactive SSH. The benefit is a short path from “work on a parallel branch” or “use a remote dev server locally” to a consistent command, without remembering a long invocation. These remain scripts with assumptions to inspect; for example, the inspected `tdl` function's final focus command refers to `opencode_pane`, although that function names its panes differently. This is a static anomaly, not a runtime-tested bug report. [Shell function manual](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/manual/20-shell-functions.md), [tmux source](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/default/bash/fns/tmux)

**Herdr is correctly spelled and bundled in the release package list.** It is not necessary to guess a similarly named tool. Its persistent terminal workspaces and AI-related integration are treated in the separate AI investigation; this report does not choose it over tmux or the existing Ghostty workflow. [Released packages](https://github.com/omacom/omarchy/blob/c668141e9c42b13c80c9ca4ea108e11708c5e8a5/install/omarchy-base.packages)

## 9. Delight extends beyond productivity applications

| Category | Evidence and status | What is interesting for this effort |
|---|---|---|
| Small focused apps | Released base includes Omawrite, Omacut and Omacalc. Current GUI documentation describes writing, trimming and calculation with narrow interfaces. [Packages](https://github.com/omacom/omarchy/blob/c668141e9c42b13c80c9ca4ea108e11708c5e8a5/install/omarchy-base.packages), [GUI descriptions](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/manual/22-guis.md) | Everyday tasks receive the same taste as the terminal. Existing Mac apps may already serve these jobs. |
| Retro music | Cliamp is in the release base and presented as a Winamp-inspired terminal player with built-in radio. [TUI manual](https://omarchy.org/manual/tuis/) | A small personal ritual can make a work environment enjoyable without affecting core tooling. |
| Personal branding | Current tooling applies personal graphics to unlock/login, ASCII screensaver and About; previews make changes inspectable. [Branding manual](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/manual/41-branding.md) | Identity is consistent in idle and transition states, not just an active terminal screenshot. |
| Newer first-party utilities | Hype, Signed and Monologue appear in current source/package inventory, absent from the inspected release base. [Current packages](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/install/omarchy-base.packages) | Interesting examples of a growing coherent app family; do not mislabel all as stable defaults. |
| Third-party shell extensions | The shell supports adding, cloning, enabling and disabling plugins; custom widgets live outside package files. Third-party content is ecosystem material, not automatically installed or guaranteed. [Plugin manual](https://omarchy.org/manual/shell-plugins/) | Build a small missing integration in the desktop's own visual language. |

The strongest aesthetic lesson is continuity across ordinary and occasional states. A purposeful lock screen, useful recording indicator and restrained transition can make the computer feel designed. Enthusiast taste need not imply maximal animations, a crowded bar or decorative telemetry.

## 10. Maintenance is part of the product—and still a cost

Current documented channels are stable, RC, edge and dev. Stable tracks releases and a delayed Arch mirror; edge follows development packages; dev links a checkout. The blessed update operation coordinates packages, migrations and restart behavior. Direct system upgrades are guarded because they bypass that coordination. This is a managed integration layer over Arch, not the same maintenance contract as plain Arch with a few dotfiles. [Update manual](https://omarchy.org/manual/updates/)

The source documents update locking, a sleep inhibitor, per-user migration state, logs and restart markers. It also names remaining issues, including missing `.pacnew`/`.pacsave` assistance and concerns about the guard's effect on legitimate package-manager workflows. This is useful evidence of maintenance work, not proof upgrades never fail. [Update design and limitations](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/docs/update-process.md)

Automatic snapshots provide a bootable recovery path on supported Limine installations. **They restore the root filesystem, not `/home` or `~/.config`.** A rollback can therefore leave newer user configuration beside older applications; personal files still need their own backup. [Snapshot manual](https://omarchy.org/manual/system-snapshots/)

Package-owned internals, user overrides and generated state have separate locations. This improves customization ownership, but explicit config reinstall can overwrite personal settings. The current bar has a further tradeoff: once a user owns `shell.json`, new default widgets do not automatically merge into it. Customization makes the user responsible for deciding which future defaults to incorporate. [File ownership](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/docs/file-layout.md), [bar configuration ownership](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/manual/05-the-top-bar.md)

**Implication for this Nix-backed Mac:** borrow the explicit separation of source settings, generated theme files and runtime state, plus a documented activation/recovery path. Do not confuse “all config is in Git” with recoverable application state, or system rollback with a personal-data backup. The configuration ownership decision remains open.

## 11. Why people like it: bounded evidence

The creator explicitly presents beauty as a source of motivation and describes the bundle as personal taste. That establishes the design intention, not a measured productivity benefit. [Official introduction](https://omarchy.org/manual/)

The following accounts are evidence of particular people reporting particular experiences. They are a small, self-selected sample, mostly enthusiasts; they do not establish representative satisfaction, comparative performance or a causal productivity gain.

| First-person source | What the person actually values | Qualifications |
|---|---|---|
| Simon Späti, September 19, 2026, after a year on Omarchy and a month on Quattro | Cohesive Quickshell behavior, fast unified nested search, useful default additions, and the ability to customize and contribute. He describes replacing his preferred screenshot tool and adding his own feature. [His account](https://www.ssp.sh/blog/omarchy-linux-quattro/) | He is a contributor and plugin author. His enthusiasm and perceived responsiveness are not benchmarks. His custom plugins are not all stock features. |
| Jaideep Khandelwal, September 16, 2025, experienced Linux and macOS user | Reduced choice overload, preset tiling, discoverable bindings, developer setup and a coherent handbook. [His account](https://one2n.io/blog/daily-driving-omarchy-linux-and-hyprland-as-a-cto) | Pre-Quattro. He also reports projector/multi-monitor and screen-sharing friction and questions long-term maintenance. Those are historical personal observations, not verified current defects. |
| Participants in a May 31, 2026 productivity discussion | Some describe workspaces and separating work from entertainment as beneficial. One explicitly preferred leaving Omarchy for Arch after finding the opinions too restrictive. [First-person discussion](https://www.reddit.com/r/omarchy/comments/1tsnxyu/has_omarchy_improved_your_workflowproductivity/) | Self-selection and unknown hardware/configurations; no vote count or anecdote is treated as a survey. |

**Synthesis, explicitly an inference:** five mechanisms plausibly explain the enthusiasm: an immediately finished baseline; fewer decisions before doing work; a coherent keyboard grammar; visible progress through shared maintenance and contributions; and permission to treat one's everyday tools as a creative object. An experienced ricer already knows the fifth. Omarchy makes the first four available without personally assembling every integration.

There is a corresponding downside to each: the baseline embodies someone else's preferences; convenience commands carry assumptions; muscle memory can conflict with app bindings; rapid development means behavior changes; and tinkering can consume time without improving the workday. The evidence supports evaluating those tradeoffs, not declaring the distro universally better than macOS.

## 12. Five experiences to bring into the Mac discussion

These are **research proposals**, not accepted requirements or tool selections. They fit the agreed priority of moving between code, terminals, browser and agents. The companion macOS and AI reports should determine feasibility.

1. **A project entry point that restores useful context.** One action opens or focuses the relevant editor, terminal/session and browser role, while a transient agent or utility remains summonable. Test whether it saves navigation during a real task; distinguish persistent processes from merely recreated windows.
2. **A personal desktop command menu with a binding browser.** Expose workspace actions, modes, capture, theme selection and common scripts under memorable names. Keep the displayed shortcuts derived from their actual source where practical. Test finding an unfamiliar command without reading a config file.
3. **One semantic visual system with explicit coverage.** Share palette, type roles, spacing intent and focus states across Ghostty, editor and themeable desktop tools. Compare concrete concepts with impeccable; record native macOS surfaces that retain their own styling. Test readability during code review, not only wallpaper composition.
4. **A finished capture-and-handoff path.** Capture, annotate/redact, optionally extract text, and attach the result without hunting for files. Test a real browser defect report and an agent image-input flow, including the distinction between pasting text, an image and a file.
5. **Attention state that can be trusted.** Surface agent attention, recording, DND and temporary keep-awake modes only when useful; ensure the user can return to the relevant context. Test interrupted work and laptop sleep/wake before adding decorative status widgets.

The next human decision is **Choose the workspace and navigation model**. A two-minute starting action is to name one real project and describe the windows used during its last code → browser → agent loop; use that session as the first prototype's content.

## Evidence limits and handoff notes

Source inspection establishes what code/configuration declares, not how it feels on hardware. No latency, battery, memory or reliability measurements were performed. No claim here establishes macOS availability of the Omarchy shell or its first-party utilities. Existing Mac apps are baseline context supplied by the coordinating investigation; their active configuration and permissions remain untested.

Do not carry v3 instructions into a Quattro design without checking them. Do not equate moving source or live manuals with the inspected stable release. Do not interpret the project direction, these proposals, or external testimonials as Nick accepting an interaction model or aesthetic. AI adoption, concrete macOS tools, visual direction and rollout remain separate human decisions.
