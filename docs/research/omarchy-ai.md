# Omarchy's AI experience and useful macOS agent workflows

**Research finding:** Herdr is the correct name, and it is genuinely bundled with Omarchy. The most useful transferable idea is an integrated place for projects, running agents, and attention—not installing every available model client. For Nick, the strongest trial candidate is **Herdr inside existing Ghostty**, compared against **Nick’s existing Codex workflow and the optional Codex desktop app** and **cmux** before choosing a terminal architecture.

Research completed 2026-10-14 for [Identify Omarchy’s AI tools and useful macOS agent workflows](https://plane.p.egregore.io/egregore/projects/e4709aa7-c911-4a7b-a9ec-f9eaa2bb905b/issues/43cc8090-926f-44b2-99f2-fc87541a9ba7/). This is decision evidence, not an accepted installation plan. No software, agent hooks, account configuration, or desktop settings were installed or activated.

## Evidence boundaries

The baseline supplied by the coordinating investigation is an M4 Max MacBook Pro with 48 GB unified memory, macOS 26.5.1, Ghostty 1.3.1, Raycast, VS Code, and Zen already present, with Codex CLI observed on PATH. A Codex desktop app installation was not established. Nick prioritizes moving between code, terminals, browser, and agents, and accepts custom scripts and regular tweaking. Presence does not establish usage, versions, subscriptions, permissions, or pain points.

| Source | Pinned evidence | Interpretation |
|---|---|---|
| Omarchy stable | [v4.0.4 release](https://github.com/omacom/omarchy/releases/tag/v4.0.4), commit `c668141e9c42b13c80c9ca4ea108e11708c5e8a5`; commit date 2026-09-14, release page September 15 | Baseline for statements that something ships. Repository redirects from basecamp to omacom. |
| Omarchy development | `quattro` at [84cfb93959f4fe0bbb71de71593b36647d2ba78d](https://github.com/omacom/omarchy/tree/84cfb93959f4fe0bbb71de71593b36647d2ba78d), commit date 2026-10-14 | Newer behavior is explicitly identified. Its `version` file still says `4.0.0.alpha`; that string is not proof that the tagged stable release is alpha. |
| Herdr | [6521382dbed36f2d001417108149c338aee116ea](https://github.com/herdrdev/herdr/tree/6521382dbed36f2d001417108149c338aee116ea), package 0.9.4; versioned 0.9.4 documentation; changelog release 2026-10-13 | Herdr's current capabilities, not proof that every Omarchy installation has this binary version. |
| Other products | Official documentation fetched 2026-10-14 | Live documentation can move; macOS 26.5.1 compatibility and workflows below have not been exercised. |

Primary-source code inspection verified installer lists, launchers, layout helpers, and versioned manuals. Browsing verified official product documentation and separate plugin ownership. No performance or reliability measurements were made. Search snippets, popularity counters, and promotional statements were not treated as implementation evidence.

## What really ships, and what does not

| Capability | Classification | Concrete evidence and consequence |
|---|---|---|
| Herdr terminal runtime | Bundled stable package | `herdr` appears in the [v4.0.4 base package list](https://github.com/omacom/omarchy/blob/c668141e9c42b13c80c9ca4ea108e11708c5e8a5/install/omarchy-base.packages). This is stronger evidence than a marketplace mention. |
| Ready-to-run coding-agent commands | Stock launchers; actual clients downloaded on demand | [mise provisioning](https://github.com/omacom/omarchy/blob/c668141e9c42b13c80c9ca4ea108e11708c5e8a5/install/user/mise.sh) wires Codex, Claude, OpenCode, Gemini, Copilot, Crush, Grok, Pi, Oh My Pi, Cursor and others. Hermes has its own install path. Authentication remains the user's job. |
| A default-agent entry point | Stock integration, user selects provider | The [default-agent selector](https://github.com/omacom/omarchy/blob/c668141e9c42b13c80c9ca4ea108e11708c5e8a5/bin/omarchy-default-agent) installs/launches the chosen tool. It does not imply free hosted inference or an Omarchy model. |
| Subscription/usage bar panel | Stock shell plugin | [Plugin contract](https://github.com/omacom/omarchy/blob/c668141e9c42b13c80c9ca4ea108e11708c5e8a5/shell/plugins/agents/README.md): Claude, Codex, Fireworks usage/limits, hiding when unused. This is different from a roster of live tasks needing attention. |
| Live Herdr task panels, remote monitors, gaming HUDs | Separate community plugins | Authors publish their own repositories; these are not evidence of default installation. See the community section below. |

### The integration is in the small transitions

The [stock Herdr shell functions](https://github.com/omacom/omarchy/blob/c668141e9c42b13c80c9ca4ea108e11708c5e8a5/default/bash/fns/herdr) provide four concrete shortcuts: `hdl` builds editor/agent/terminal panes, optionally with a second agent; `hds` pairs Neovim, a watched diff, shell, and OpenCode; `hdlm` makes layouts for child directories; `hsl` starts a command in a grid. This is a working-session vocabulary, not merely a package list. However, `hsl` uses the same current directory throughout: a grid of agents does not create separate checkouts or prevent file conflicts. `hdlm` organizes directories; it does not decide task ownership.

[Aliases](https://github.com/omacom/omarchy/blob/c668141e9c42b13c80c9ca4ea108e11708c5e8a5/default/bash/aliases) put Herdr behind `h`, the default agent behind `a`, and selected clients behind short commands. The [launcher](https://github.com/omacom/omarchy/blob/c668141e9c42b13c80c9ca4ea108e11708c5e8a5/bin/omarchy-agent) centralizes dedicated terminal behavior. These defaults include agent-specific approval modes; copying the aliases would copy those choices. Nick's acceptance of maintenance is not an acceptance of all approval bypasses. A macOS translation should make launching effortless while retaining the chosen agent permission policy.

The [mise wrapper generator](https://github.com/omacom/omarchy/blob/c668141e9c42b13c80c9ca4ea108e11708c5e8a5/bin/omarchy-mise-install) installs on invocation and sets its release-age cooldown to zero. That reduces onboarding friction but creates a moving version boundary. Provisioning also disables automatic pruning of old mise versions so live processes do not lose their executable directory. For this Nix-oriented repo, one explicit owner per tool is preferable to recreating competing mise, Homebrew, Nix, and vendor updaters.

### Other AI-related goodies

| Experience | Stock or optional | Why it matters on this Mac |
|---|---|---|
| Theme propagation into agents | Stock | [Theme application](https://github.com/omacom/omarchy/blob/c668141e9c42b13c80c9ca4ea108e11708c5e8a5/bin/omarchy-theme-set) calls Claude, Pi, and Hermes setters and refreshes OpenCode. A shared palette can include the agent rather than stopping at the terminal background. |
| Agent-guided desktop customization | Stock skills | The [Omarchy skill](https://github.com/omacom/omarchy/blob/c668141e9c42b13c80c9ca4ea108e11708c5e8a5/default/agents/skills/omarchy/SKILL.md) supplies concrete config locations, theme/plugin guidance and maintenance rules. The transferable asset is a similarly accurate macOS configuration guide; the Linux skill itself is not suitable for this Mac. |
| Click a crash notification to investigate | Stock | [Crash launcher](https://github.com/omacom/omarchy/blob/c668141e9c42b13c80c9ca4ea108e11708c5e8a5/bin/omarchy-agent-crash) gathers systemd-coredump context and points the default agent to a diagnosis skill. macOS would need its own log/report collector and explicit data-selection step. |
| Dictation and text extraction | Dictation optional; OCR documented desktop feature | [Manual](https://github.com/omacom/omarchy/blob/c668141e9c42b13c80c9ca4ea108e11708c5e8a5/manual/11-text-extraction-dictation.md) offers Voxtype push-to-talk/toggle dictation and screen-region Tesseract OCR. The attractive flow is capture → text → current input; there is no reason to install its Linux implementation on macOS. |
| Local models and graphical AI apps | Optional menu installs | [Stable AI manual](https://github.com/omacom/omarchy/blob/c668141e9c42b13c80c9ca4ea108e11708c5e8a5/manual/17-ai.md) offers LM Studio/Ollama and desktop or gateway apps including Hermes/OpenClaw. Optional presence is not a reason to add an always-running personal agent gateway to a coding desktop. |

The development branch has materially more features than the release: its [AI manual](https://github.com/omacom/omarchy/blob/84cfb93959f4fe0bbb71de71593b36647d2ba78d/manual/17-ai.md) describes multiple subscription accounts, switching and threshold-based notifications, additional providers, and agent-assisted creation prompts. Its Claude selection also attempts Chromium-family browser integration; Zen is explicitly unsupported by that extension. These findings should not be retroactively attributed to v4.0.4. Account switching and credential copying are particularly poor candidates for casual transplantation: they couple to provider login layouts and token behavior.

## Herdr: the name and the useful capability

The exact match is [herdr.dev](https://herdr.dev/) and its linked [herdrdev/herdr repository](https://github.com/herdrdev/herdr). The user spelled it correctly. [Laravel Herd](https://herd.laravel.com/) is a different development-environment product. A separate `herdr.org` marketing result is not the repository linked by Omarchy's actual package/tool usage; no relationship was established. Matching the spelling alone would have been insufficient.

Herdr is an Apache-2.0 terminal runtime/multiplexer, with a background server and a terminal client. It runs inside Ghostty; it does not replace Codex's reasoning model or provide a model subscription. Official [installation documentation](https://herdr.dev/docs/install/) offers macOS builds, Homebrew, mise, and a source-building Nix flake. Apple Silicon support does not establish measured performance or macOS 26.5.1 reliability on Nick's machine.

### Attention is the strongest improvement

Herdr recognizes supported agent processes and derives `working`, `blocked`, `idle`, and unseen completion state. Those states roll upward from panes to tabs and workspaces. The sidebar answers “which project needs me?” without opening every terminal. Agents that report state directly provide a stronger signal; other integrations inspect the live terminal display. [Pinned agent behavior](https://github.com/herdrdev/herdr/blob/6521382dbed36f2d001417108149c338aee116ea/docs/versions/0.9.4/website/src/content/docs/agents.mdx).

This is not a proof-of-completion system. Unknown approval dialogs may look idle; native background jobs can continue after an agent returns to its prompt. A done badge means attention is available, not tests passed. Herdr documents `agent explain` for detection failures, and can fetch updated detection manifests independently of a binary update. Maintenance therefore includes both tool versions and detection rules. A toolbar should preserve “unknown” and “unavailable” rather than presenting them as green.

### Navigation and worktrees

Herdr's [configuration contract](https://github.com/herdrdev/herdr/blob/6521382dbed36f2d001417108149c338aee116ea/docs/versions/0.9.4/website/src/content/docs/configuration.mdx) supports grouped Git worktrees, creating/opening checkouts as workspaces, and closing a group without deleting its files. Explicit checkout deletion uses Git's safe removal first. This can support one repository group with one workspace per task and agent/editor/test panes inside each. The checkout is isolation for files and Git branch state; it does not isolate network ports, databases, credentials, or external side effects.

The same configuration surface provides in-app, terminal, and system notification delivery. On macOS, system delivery tries `terminal-notifier`, then AppleScript; the fallback appears as Script Editor and cannot activate the hosting terminal. Exact notification-click-to-pane behavior must be tested, not inferred from Linux screenshots. Prefer one route for “needs input” and a quiet persistent badge for “ready to review” to avoid duplicate alerts from the agent, terminal, and bar.

### Persistence has several different meanings

| Event | What to expect |
|---|---|
| Close/detach the client | The separate server can keep its original processes alive. |
| Restart the server or reboot | Original processes end. Layout can return; eligible agent conversations resume through integrations. Arbitrary tests/dev servers do not magically continue. |
| Enable saved screen history | Recent terminal output can replay, but this does not restore a process. It is off by default because output may contain secrets. |
| Sleep the local Mac | Local computation pauses during actual system sleep. A multiplexer is not a way to keep a sleeping CPU working. |
| Disconnect from a remote awake host | Server-side work can continue there; later reconnect restores access. The host must remain available and have the needed code and credentials. |

The first three distinctions come from Herdr's [versioned restore documentation](https://github.com/herdrdev/herdr/blob/6521382dbed36f2d001417108149c338aee116ea/docs/versions/0.9.4/website/src/content/docs/session-state.mdx); remote continuity is described in [the remote guide](https://herdr.dev/docs/persistence-remote/). The sleep distinction is the physical limit of the proposed architecture, not an interpretation of the site's “close the lid” marketing. Experimental live server handoff is a separate mechanism and must not be promised as universal restart survival.

### Orchestration is possible, but it still needs a work contract

Herdr's [automation API](https://herdr.dev/docs/agent-automation/) can create layout, start a named agent, submit prompts, inspect output, and wait for semantic state. Commands return identities; scripts should use those returned identities rather than guess pane numbers. Prompt waits are not per-turn transaction IDs: an existing active turn can satisfy a wait, and a timeout does not prove nothing was submitted. Blind retries can duplicate work.

A sensible later script could create two isolated task worktrees, launch implementation and review agents, and expose “waiting” items. It still needs explicit branch ownership, success evidence, who merges, and cleanup rules. A swarm grid is not that contract. This research does not authorize unattended delegation or automatic approvals.

Herdr's [Codex integration documentation](https://github.com/herdrdev/herdr/blob/6521382dbed36f2d001417108149c338aee116ea/docs/versions/0.9.4/website/src/content/docs/integrations.mdx) says it writes a state hook, `hooks.json` entries and feature configuration, and recommends `--no-daemon` for reliable per-pane reports because a shared daemon can misroute hooks. This is Herdr's integration claim, not a guarantee about Nick's installed Codex build. Uninstall removes its hook entries but leaves the feature configuration change. Any trial must inspect existing hooks first and record the diff; otherwise “remove Herdr” would not fully revert the trial.

### Real maintenance and trust boundaries

Herdr's [0.9.4 changelog](https://github.com/herdrdev/herdr/blob/6521382dbed36f2d001417108149c338aee116ea/CHANGELOG.md) records recent fixes for macOS shutdown persistence, shell-parent exit, input handling and resource use; it also notes a remaining zsh/Powerlevel10k redraw problem. These are useful test targets, not evidence of a flawless mature layer. Native Ghostty keybindings, a multiplexer prefix, and agent shortcuts need one deliberate hierarchy.

Herdr's [plugins](https://github.com/herdrdev/herdr/blob/6521382dbed36f2d001417108149c338aee116ea/docs/versions/0.9.4/website/src/content/docs/plugins.mdx) are executable code running as the user, with inherited environment and full CLI access. They are not sandboxed by the manifest. The local socket is a control surface that can inspect terminal output and send input; any bridge or menu integration should expose only the operations it needs. Avoid storing prompts, credentials, or transcript captures in dotfiles, bar caches, or sync folders by accident.

## Community integration versus stock integration

[Herdr Companion for Omarchy](https://github.com/matt-shearing/omarchy-herdr) polls the Herdr agent list, sorts waiting/reviewable/running states, and focuses a selected pane and Ghostty window. It names Omarchy 4.0.1/Herdr 0.8.2 as tested and depends on Hyprland/Quickshell. Its value is a small ambient indicator that becomes prominent only when action is needed. Its code is not a macOS widget.

[Herdr Monitor](https://github.com/IgorWarzocha/omarchy-herdr) instead subscribes to Herdr events and includes saved SSH machines. The author reports Omarchy 4.0.3/Herdr 0.9.0 testing. It is read-only monitoring but can contact configured SSH targets, including their ProxyCommand/ProxyJump behavior. Neither repository proves the official bar already has that functionality.

[Herdr HUD](https://github.com/finna/omarchy-herdr-hud) adds a floating terminal/chat view and prompting over fullscreen games. It is a separate community project, with terminal-pattern parsing for recognized output. For Nick, the transferable idea is a quick attention overlay; gaming overlays and prompt injection from a desktop widget should wait for demonstrated need.

## The macOS options worth comparing

| Candidate | Best fit | Additional cost or responsibility |
|---|---|---|
| Existing Codex CLI + Ghostty + Raycast; optional Codex desktop app | Predominantly Codex work, with a possible app-based review/worktree workflow | Establish Nick’s current workflow and whether the desktop app is desired; do not assume it is installed. |
| Ghostty + Herdr | Multiple CLI agents/projects, SSH continuity, terminal-first work | Another navigation layer, server lifecycle, integration hooks and state-detection maintenance. Strongest direct Omarchy transfer. |
| cmux | Native macOS terminal workspaces with integrated browser and attention UI | Separate terminal application replacing Ghostty's role for these sessions, despite sharing its rendering technology. |
| Ghostty with a small notification/project launcher layer | Few simultaneous agents; current friction is mostly opening/finding things | Less unified agent state, but fewer moving parts. |
| Local runner as an optional adjunct | A concrete offline/privacy/small-assistance task | Model downloads, unified-memory contention, power use, quality evaluation and endpoint management. |

### The Codex desktop app is another option for worktree isolation

Official [worktree documentation](https://learn.chatgpt.com/docs/environments/git-worktrees) describes managed task checkouts, handoff between local and worktree environments, setup-file copying, cleanup, and restoration snapshots. That makes “give every task its own checkout” a capability to assess in the Codex desktop app before choosing a separate orchestration layer. The app was not found in the baseline inspection. Managed worktrees can be automatically cleaned up; permanent/pinned work has different treatment. Nick's CLI version, desktop-app availability and preferred workflow still need inspection.

A Herdr UI would be most valuable for terminal agents and processes outside that app. It should not claim to observe every Codex desktop conversation merely because it recognizes the CLI. Nor should both systems independently manage deletion of the same checkout. Choose a worktree owner and have other tools open that owner's directories.

### cmux is a substantive alternative

[cmux's official README](https://github.com/manaflow-ai/cmux/blob/main/README.md) describes a native macOS app using libghostty, with vertical workspaces, split panes, branch/port information, an embedded browser, and a CLI/socket interface. Ghostty rendering configuration can carry over. It is a separate app, not a Ghostty plugin; its browser does not automatically inherit Zen's sessions/extensions. No Omarchy default installation was established for cmux.

Its [notification documentation](https://cmux.com/docs/notifications) covers pane rings, unread indicators, navigation to unread items, terminal escape sequences and CLI/hook notification paths. This could make “agent finishes → inspect preview beside code” particularly smooth. “Any CLI runs” should not be confused with “every CLI reliably emits attention events.” Validate actual agents and notification routes. Compare cmux directly against Herdr before nesting one inside the other: two workspace sidebars and two alert owners can increase the switching problem.

### Raycast is the front door, not necessarily another AI subscription

[Script Commands](https://manual.raycast.com/script-commands) can expose local scripts with metadata and arguments. Proposed commands could open a chosen project, focus an existing agent workspace, or list tasks needing input. This does not require adopting Raycast AI. A first version can use an explicit project registry and Herdr IDs, rather than scraping arbitrary window titles. A graphical roster may warrant a proper extension later; begin with a few named actions.

Ghostty's [configuration reference](https://ghostty.org/docs/config/reference#notify-on-command-finish) documents command-finish notifications since 1.3.0, conditional on focus and shell integration/OSC 133. These are useful for builds and tests, but an interactive agent can remain running through many completed turns. Shell-command completion therefore does not replace agent lifecycle notifications. The baseline inspection found Ghostty 1.3.1, which meets that documented version threshold; notification delivery and focus behavior remain untested.

## Local models on this M4 Max

Ollama's [macOS requirements](https://docs.ollama.com/macos) include Apple Silicon acceleration; LM Studio's [requirements](https://lmstudio.ai/docs/app/system-requirements) cover Apple Silicon and recommend at least 16 GB memory. The supplied 48 GB machine clears those broad prerequisites. It does not follow that a specific large model, long context, multiple agents, browser, editor, and Docker will all fit comfortably at once.

Choose the job before a model. Plausible trials are offline short-text rewriting, local repository question answering with bounded context, or a local transcription flow. Measure quality, time to useful answer, peak memory, and the effect on the active desktop. There is no benchmark in this report establishing that a local model can replace Nick's preferred hosted coding agent. Weights, quantization, KV cache, context length and concurrency all affect the resource budget.

[Ollama's FAQ](https://docs.ollama.com/faq) distinguishes local processing from cloud-hosted models and documents a local-only setting, loopback binding by default, model storage, and memory effects from parallel context. Ollama now having cloud features means “uses Ollama” is not sufficient evidence that data stays local. Its Docker guidance says macOS Docker Desktop does not provide the GPU acceleration path; a native runner is the relevant evaluation target.

[LM Studio's offline guide](https://lmstudio.ai/docs/app/offline) says downloaded models can run offline and distinguishes that from model discovery/downloads, updates and other network features. It offers a comfortable manual exploration path; Ollama suits shell/API integration. Do not install both unless the trial finds a distinct need. Model licenses and chosen clients' telemetry/tool calls remain separate from the runner's local inference behavior.

## Accounts, data, and operating cost

| Boundary | What the plan must record |
|---|---|
| Hosted agents | Herdr/cmux do not include provider inference. Confirm Nick's existing login method, entitlements, organizational rules and usage limits with the chosen provider. No price or account entitlement is inferred here. |
| Local runtime and history | Session snapshots, hook state, terminal output and transcripts belong outside the public repo. Local model execution does not make remote tools called by an agent local. |
| Usage dashboards | Omarchy's collectors read local transcripts and provider-specific authenticated usage endpoints. Its optional sync directory exports usage summaries across machines; “display-only panel” does not mean the whole collector pipeline reads nothing sensitive. |
| Remote execution | The remote machine needs working directories, runtime tools and authentication. SSH detachment preserves server-side work, not files that only exist on the laptop. Decide the credential strategy separately from terminal attachment. |
| Ownership and updates | Pin or explicitly choose update policy for runtime, integration hooks, detection manifests and plugins. Keep provider credentials, tokens, browser profiles and local model caches out of Nix/store artifacts and Git. |

The usage-collector behavior is documented in the [stable agents plugin contract](https://github.com/omacom/omarchy/blob/c668141e9c42b13c80c9ca4ea108e11708c5e8a5/shell/plugins/agents/README.md). Its Codex totals have a scan-window limit and Fireworks balance may be an estimate; a polished gauge should not be presented as billing truth. For Nick's first desktop iteration, live attention is likely more consequential than a comprehensive token dashboard—this is a research recommendation, subject to his workflow.

## Concrete flows to test in the next decision

1. **Open a project once.** A launcher action focuses its existing workspace, with correct directory, editor, shell and browser destination; repeating the action does not spawn duplicates. Try this in the current stack before adding a runtime.
2. **Let two tasks run.** Use isolated worktrees. Work on something else, then find the agent waiting for input directly. Confirm the badge distinguishes waiting from completed and does not expose prompt text on the lock screen.
3. **Review and resume.** Move from the completed agent to diff/tests/preview, answer once, and return to the prior context. Establish which app owns the checkout and cleanup.
4. **Leave and return.** Test client detach separately from server restart, Mac sleep and remote disconnect. Check what actually continues, what reopens, and what requires manual restart.
5. **Change the visual theme.** Keep project and attention meaning consistent across terminal, agent UI and any bar/launcher surface. Use text/icon shape as well as color; show an unavailable state clearly.

These are acceptance scenarios for later trials, not passing test results. They are sized around the destination: a daily driver that is pleasant to use. A useful comparison should record action counts, missed/duplicate notifications, lost context and recovery surprises rather than benchmark software by feature count.

## Decisions still owned by Nick

1. Are active sessions primarily in the Codex CLI, an IDE, or a desktop app, and how many unrelated tasks commonly run simultaneously?
2. Should a project contain browser/editor/agent windows at the desktop level, or should a terminal workspace own most of that context?
3. Is an always-awake remote machine part of the intended routine, or is local suspend/resume sufficient?
4. What should interrupt immediately, and what should wait in a quiet review queue? Is usage tracking important enough to read provider state?
5. Is there a specific local/offline AI task worth the memory and maintenance cost now?

**Next action, under two minutes:** describe one recent moment when finding, waiting for, or returning to an agent interrupted your coding flow. Use that example to choose the first comparison between the existing stack, Herdr, and cmux.
