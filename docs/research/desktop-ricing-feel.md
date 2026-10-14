# Desktop ricing: feel, examples, and things worth stealing

Research date: **14 October 2026**. This is a visual and experiential notebook for customizing Nick's MacBook. It supports [Explore Omarchy and r/unixporn as complete desktop setups](https://plane.p.egregore.io/egregore/projects/e4709aa7-c911-4a7b-a9ec-f9eaa2bb905b/issues/b2ba9a47-7aae-462b-a7a6-76884ea8102f/) within [Shape a distinctive macOS daily driver inspired by Omarchy](https://plane.p.egregore.io/egregore/projects/e4709aa7-c911-4a7b-a9ec-f9eaa2bb905b/issues/7d839361-92ca-440f-b7b0-1e85f9b38167/). No software was installed or activated.

**The strongest common thread is a computer with a recognizable personality.** Wallpaper, terminal, window framing, browser, music player, launcher and small interactions feel related. Some setups are comfortable and understated; others are deliberately theatrical. A music visualizer or pixel clock can be worthwhile simply because it makes the machine enjoyable.

The examples below are a deliberately varied selection, not a ranking or a representative survey of r/unixporn. Author statements establish what they built; screenshots establish appearance. Neither establishes battery life or months of reliability. Visual interpretations are mine. Reddit's image CDN was inaccessible, so I inspected author-hosted repository images where possible and explicitly mark the remaining text-only references. Newer repository pictures are not silently treated as the original Reddit post. Linked images remain on their authors' hosting; no third-party artwork is copied into this repository.

## Four macOS examples

### Mellow: soft color, almost invisible framing

[SamuelOIAF / samkaj's original post](https://www.reddit.com/r/unixporn/comments/1gbsbtd/aerospace_mellow_macos_setup/) · [author's dotfiles](https://github.com/samkaj/dots.macos)

![samkaj's Mellow macOS desktop, from the author's repository](https://raw.githubusercontent.com/samkaj/dots.macos/edc8ca5eeaf459902162a623a0f6cb911a4aba15/pics/example.png)

**Seen:** near-black warm surfaces, muted lilac/pink/green syntax, narrow gaps, very restrained rounded edges, a thin full-width top bar. The editor occupies most of the screen; a second terminal carries Git output and a decorative fetch. The little pink editor-mode pill has more emphasis than the window frames. This feels settled and quiet without becoming monochrome.

**Ingredients:** AeroSpace, SketchyBar, iTerm2, Neovim, Raycast, JetBrains Mono and the Mellow palette. The author generated the wallpaper from the theme colors, a useful reversal of the usual wallpaper-first process. They report that they stopped using native fullscreen; this is their practice, not evidence that every fullscreen interaction works. [Author's explanations](https://www.reddit.com/r/unixporn/comments/1gbsbtd/aerospace_mellow_macos_setup/).

**Steal:** coordinated muted surfaces and a few colored landmarks. Ghostty can supply the terminal surface already installed on this Mac; adopting iTerm or Neovim is not inherent to this look.

### Purple Mac: tactile controls and a little space opera

[fumblecheese / adriankarlen's original post](https://www.reddit.com/r/unixporn/comments/1j245bj/aerospace_purple_mac_with_wm_goes_brrr/) · [author's current dotfiles](https://github.com/adriankarlen/dots)

![adriankarlen's later repository screenshot: purple terminal and star-field wallpaper](https://github.com/user-attachments/assets/440b8567-9f7a-43c3-8d6c-1b220e3e2e56)

**Seen in the later repository image:** a centered Ghostty/editor window, a fine lilac border, deep plum backgrounds and an expansive star-field wallpaper. Small colored glyphs carry the bar; a now-playing title occupies its right side. This image gives the wallpaper much more room than Mellow's working layout.

**Original-post ingredients:** AeroSpace, SketchyBar, Ghostty, Rosé Pine Moon, Arc, Neovim, Comfy for Spotify and themed Legcord. The author says the bar's buttons animate down into their shadows when clicked. That tactile detail is more distinctive than another rounded rectangle. They also acknowledge an unresolved media-widget issue; published dots are not a polished distribution. [Original author comments](https://www.reddit.com/r/unixporn/comments/1j245bj/aerospace_purple_mac_with_wm_goes_brrr/).

**Steal:** a deliberate visual world and one satisfying interaction. The later picture and original list document different revisions, not one verified present-day stack.

### Nordic Mac: typography and useful terminal graphics

[DrConverse / theopn's original Nordic post](https://www.reddit.com/r/unixporn/comments/1kndhaj/aerospace_functional_nordic_macos_setup_easy_for/) · [author's dotfiles](https://github.com/theopn/dotfiles)

![A later theopn macOS screenshot pairing a sunset wallpaper with blue-gray terminals](https://raw.githubusercontent.com/theopn/dotfiles/ff5516d9a2b8c78c1d10f1c86c95ec310f0e848d/assets/macos-sc.jpg)

**Seen in the later repository image:** a split illustration of the busy and empty desktop, warm salmon sunset against blue-gray panes, compact capsule groups in the bar, colored terminal statuses and an actual image preview in the file browser. It shows how wallpaper color can remain expressive while work surfaces stay quieter. The later image uses Kitty and visibly different typography; it is not the original Nordic screenshot.

**Original-post ingredients:** AeroSpace, SketchyBar, Neovide with Nordfox, WezTerm, LF with chafa image previews, Alfred with a Nord theme, and Zen with Winter Spirit. The author particularly enjoys Neovide's animation, rendering and smoothness while still sometimes using terminal Neovim. That is evidence that the pleasure includes how text moves and renders, not only a palette. [Author's post and comments](https://www.reddit.com/r/unixporn/comments/1kndhaj/aerospace_functional_nordic_macos_setup_easy_for/).

**Steal:** warm wallpaper/cool working surfaces; tune type and line spacing; useful inline media instead of only fetch logos.

### Cyberpunk Mac: native type, ASCII texture, and agents

[HanzoSamori / gcodenowski's original post](https://www.reddit.com/r/unixporn/comments/1ri0wuk/yabai_my_first_macos_rice/) · [author's pinned dotfiles](https://github.com/gcodenowski/dotfiles/tree/f4f3dad0116d6d4b42fca156ea15b28053dbc960)

[Watch the author's repository GIF](https://raw.githubusercontent.com/gcodenowski/dotfiles/f4f3dad0116d6d4b42fca156ea15b28053dbc960/assets/screenRec.gif).

**Seen:** the first frame of that later GIF, not the full animation: electric-blue/black ASCII texture, a bright thin rounded window outline, a dense top bar, and a large terminal/editor dashboard. Transparency makes the wallpaper part of the terminal, much more aggressively than Mellow.

**Original-post ingredients:** yabai and JankyBorders with SIP enabled, Kitty/Fira Code, SketchyBar with SF Pro and SF Symbols, Neovim, Spotify/Spicetify. The author made the wallpaper with ascii-image-converter. The later repository adds **Herdr, OpenCode, Superfile and a dynamic `os_theme` script**; it explicitly describes its own setup as unstable. [Original author](https://www.reddit.com/r/unixporn/comments/1ri0wuk/yabai_my_first_macos_rice/), [repository README](https://github.com/gcodenowski/dotfiles/blob/f4f3dad0116d6d4b42fca156ea15b28053dbc960/README.md).

**Steal:** Mac-native SF typography can coexist with an expressive Unix aesthetic. Agent tools already appear as ordinary inhabitants of a riced Mac, rather than requiring a separate dashboard product.

## Five contrasting Linux references

### Retro pixel: hot pink, hard edges, custom controls

[\_zev\_\_ / qxb3's original post](https://www.reddit.com/r/unixporn/comments/1ie997w/hyprland_tried_retro_pixel/) · [retro branch](https://github.com/qxb3/conf/tree/82e9e3fa926e4594b518f6c8e8ae86c90e03f45d)

![qxb3's retro pixel desktop with music and power panels](https://raw.githubusercontent.com/qxb3/conf/82e9e3fa926e4594b518f6c8e8ae86c90e03f45d/repo/2.png)

**Seen:** vivid pixel-art landscape; near-black cards; cream hairline outlines; magenta selected controls; angular pixel lettering. Workspaces, power controls, music and resource bars share the same graphic vocabulary. Floating terminals show a visualizer and fetch; the screenshot deliberately opens several controls at once.

The author identifies Pixelify Sans and AGS for the custom menus. The repository documents Hyprland, a sidebar, wallpaper selector, launcher, special workspace, and capture commands via grim/grimblast and swappy. This is a real implemented shell, but the composition is a showcase, not proof that all those panels remain open during work. [Post](https://www.reddit.com/r/unixporn/comments/1ie997w/hyprland_tried_retro_pixel/), [README](https://github.com/qxb3/conf/blob/82e9e3fa926e4594b518f6c8e8ae86c90e03f45d/README.md).

**Steal for Mac:** pixel wallpaper, bar font, sharp outlines and a small themed music widget. Replicating every AGS panel would be a separate build; the visual identity does not depend on that.

### Awesome95: floating windows are absolutely a rice

[pitersios / palebIood's original post](https://www.reddit.com/r/unixporn/comments/1kgnpy2/awesomewm_yet_another_retro_webcore_rice/) · [author's repository](https://github.com/palebIood/awesome95)

![Awesome95: overlapping gray beveled windows over a teal desktop](https://raw.githubusercontent.com/palebIood/awesome95/58a2f4d42d2092c0fe345433557578a7b1cb23f2/screenshot_003.png)

**Seen:** teal background, gray beveled chrome, navy active titlebars, icon-heavy status strip, bottom taskbar and overlapping windows. Classic widgets frame VS Code, a terminal, file manager and small text editor. It feels like a lived-in older workstation, not a presentation grid.

**Ingredients:** AwesomeWM, Chicago95 GTK theme, classic95 icons, Alacritty, LessPerfectDOSVGA terminal type and Inconsolata UI text. The author explicitly wanted retro GUI aesthetics and says they were happy with the result without knowing its eventual use. The README flags machine-specific disk widgets and missing setup dependencies. [Author post](https://www.reddit.com/r/unixporn/comments/1kgnpy2/awesomewm_yet_another_retro_webcore_rice/), [README](https://github.com/palebIood/awesome95/blob/58a2f4d42d2092c0fe345433557578a7b1cb23f2/README.md).

**Steal for Mac:** nostalgia through wallpaper, icons where supported, terminal type, sound and music. Do not promise GTK-style global replacement of native macOS chrome. The important precedent is permission to enjoy floating windows and ornament.

### end-4: the whole desktop as an animated control surface

[void1273 / end-4's Quickshell showcase post](https://www.reddit.com/r/unixporn/comments/1ls4xdv/hyprland_my_virginity_defense_ft_quickshell/) · [author's current project and video](https://github.com/end-4/dots-hyprland)

![end-4's current repository screenshot with a coordinated AI sidebar and settings](https://github.com/user-attachments/assets/5d4e7d07-d0b4-4406-a4c9-ed7ba90e3fe4)

![end-4's current widgets screenshot: olive panels, music, system controls and calendar](https://github.com/user-attachments/assets/6a32395f-9437-4192-8faf-2951a9e84cbe)

**Seen:** large rounded Material-like panels, wallpaper-derived lavender or olive colors, broad sliders, grouped toggles, generous sans-serif type, music artwork and an integrated AI sidebar. The current widget screenshot has a vertical edge bar; this is broader than the familiar top-bar-and-terminal composition.

The original author describes custom workspace previews, a settings surface, and clock placement based on image-region analysis. Current upstream advertises live window overview, AI including Gemini/Ollama, screen translation, Google Lens and anti-flashbang. Its old AGS style is now explicitly unsupported; present recommendations must refer to the Quickshell version. I inspected current stills, not the complete original video. [Author explanation](https://www.reddit.com/r/unixporn/comments/1ls4xdv/hyprland_my_virginity_defense_ft_quickshell/), [current source/README](https://github.com/end-4/dots-hyprland).

**Steal for Mac:** the coordinated arrival of launcher, controls, music and AI when summoned. Exact compositor effects and this shell are Linux-specific; a full port is unnecessary to borrow the mood.

### Noctalia with niri: a complete-feeling desktop around scrolling windows

[CynexV2's original Noctalia post](https://www.reddit.com/r/unixporn/comments/1ndsdq0/niri_noctalia/) · [current Noctalia project](https://github.com/noctalia-dev/noctalia) · [niri](https://github.com/niri-wm/niri)

**Evidence limit:** original image unavailable for inspection; this entry uses the developer's comments and official capabilities, not a visual description invented from a thumbnail.

The author confirms wallpaper-derived colors through Matugen and explains the themed shell's relationship to GTK apps. A later commenter describes discovering that installation already delivered the expected pieces. This suggests an appeal similar to Omarchy: coherent assembly with fewer missing parts. It is anecdotal evidence, not a general satisfaction measurement. [Original thread](https://www.reddit.com/r/unixporn/comments/1ndsdq0/niri_noctalia/).

Current Noctalia combines bar, dock, launcher, control center, notifications, lock screen, wallpaper, clipboard, overlays and widgets. **Version distinction:** the current repository describes a native Wayland/OpenGL ES implementation without Qt/GTK; the 2025 showcase belongs to the earlier Quickshell generation. [Current upstream](https://github.com/noctalia-dev/noctalia).

niri supplies the physical feeling: windows in columns along a horizontal strip, existing widths preserved when another opens, vertical dynamic workspaces, an overview and gestures. That combination can feel like moving across a desk rather than continually subdividing a page. The analogy is interpretation; the mechanics are documented. [niri upstream](https://github.com/niri-wm/niri).

**Steal for Mac:** evaluate scrolling as its own enjoyable motion style; borrow coherent controls. Do not describe niri or Noctalia as macOS apps.

### Blind2Obsession: the same ingredients can become angular and desaturated

[cooolloooll's original niri post](https://www.reddit.com/r/unixporn/comments/1s61leq/niri_blind2obsession/)

**Evidence limit:** screenshot inaccessible; author-described direction only. The author explains moving away from a rounded top bar after seeing dwm/i3 setups, toward hard angles and desaturation. Components are niri, Noctalia, Konsole and monochrome Suru icons. They credit the wallpaper artists but have not supplied the color-scheme export in the inspected post. [Author's description](https://www.reddit.com/r/unixporn/comments/1s61leq/niri_blind2obsession/).

**Why include it:** it prevents confusing tool choice with taste. A modern animated compositor does not imply pastel pill controls. The same underlying tools can support a much colder, denser character. On Mac, shape, typography and restrained color are separate choices from whether to tile windows.

## What Omarchy adds to this picture

Omarchy is a useful reference for **coordinated, changeable character**. Its official theme previews demonstrate substantially different moods in the same working arrangement. The coordinating researcher inspected the following official images; they are static demonstrations, not benchmarks or live sessions.

| Official theme | Character observed | Reference |
|---|---|---|
| Gruvbox | Charcoal, ochre and moss; muted warmth | [Preview](https://raw.githubusercontent.com/omacom/omarchy/84cfb93959f4fe0bbb71de71593b36647d2ba78d/themes/gruvbox/preview.png) |
| Retro 82 | Navy, orange and teal; strong rectangular framing | [Preview](https://raw.githubusercontent.com/omacom/omarchy/84cfb93959f4fe0bbb71de71593b36647d2ba78d/themes/retro-82/preview.png) |
| Solitude | Near-black and gray, sparse red; rounded frames | [Preview](https://raw.githubusercontent.com/omacom/omarchy/84cfb93959f4fe0bbb71de71593b36647d2ba78d/themes/solitude/preview.png) |
| Lumon | Cool slate and icy blue; straight frames | [Preview](https://raw.githubusercontent.com/omacom/omarchy/84cfb93959f4fe0bbb71de71593b36647d2ba78d/themes/lumon/preview.png) |
| Flexoki Light | Ivory paper and ink with restrained syntax color | [Preview](https://raw.githubusercontent.com/omacom/omarchy/84cfb93959f4fe0bbb71de71593b36647d2ba78d/themes/flexoki-light/preview.png) |

This suggests treating a theme as a small coordinated set—wallpaper, terminal/editor colors, bar, borders, browser surfaces—rather than choosing one permanent wallpaper and individually adjusting everything for hours. It also leaves room for light themes and seasonal alternatives. That is a proposal inspired by the previews, not an accepted requirement.

For the deeper Omarchy package/integration and AI inventory, retain the existing [experience report](https://github.com/NickSeagull/dotfiles/blob/research/omarchy-experience/docs/research/omarchy-experience.md) and [AI report](https://github.com/NickSeagull/dotfiles/blob/research/omarchy-ai/docs/research/omarchy-ai.md). This notebook corrects the emphasis: integrated behavior matters alongside atmosphere, play and visual identity.

## Concrete ingredients worth bringing to this Mac

The existing Ghostty, Raycast, Zen, VS Code and AltTab provide plenty of surfaces to customize. The following is a transfer map, **not an installation list or a settled architecture**. Official support is not a test on Nick's particular machine.

| Desired feel | Concrete Mac ingredients | What transfers, and what does not |
|---|---|---|
| Calm, coherent working surfaces | Ghostty palette/type/padding; matching editor and browser themes; wallpaper in related tones | High visual return from things already present. Ghostty exposes themes, font options, opacity, blur and macOS titlebar settings. Themeable apps can coordinate; arbitrary native dialogs do not inherit a universal palette. [Ghostty reference](https://ghostty.org/docs/config/reference) |
| A desktop edge with personality | SketchyBar plus optional JankyBorders | Custom fonts, music/workspace/status items, popup controls, animated bar properties and focus outlines. SketchyBar documents animation curves and queued transitions; it does not become the Mac compositor. [SketchyBar](https://felixkratz.github.io/SketchyBar/config/animations), [JankyBorders](https://github.com/FelixKratz/JankyBorders) |
| Crisp keyboard-driven tiling | AeroSpace; optionally yabai for native Spaces | AeroSpace's i3-like workspace model and animation-free switching differ from yabai's native-Space tiling. Either can host many looks. Ordinary yabai use does not inherently require disabling SIP. [AeroSpace](https://github.com/nikitabobko/AeroSpace), [yabai](https://github.com/asmvik/yabai) |
| Scroll or gesture pleasure | PaperWM.spoon; alternatively Loop for radial placement | PaperWM.spoon supplies scrolling tiling through Hammerspoon; Loop supplies a radial window-placement interaction and previews. These are possible interpretations of enjoyable motion, not niri ports or substitutes proven on this Mac. [PaperWM.spoon](https://github.com/mogenson/PaperWM.spoon), [Loop](https://github.com/MrKai77/Loop) |
| Personal desktop objects | Übersicht, music tools, selective bar widgets | Übersicht runs commands and displays HTML/JS widgets: a clock, album card or custom scene can be an enjoyable desktop object. It does not provide Linux session-lock or compositor APIs. [Übersicht](https://tracesof.net/uebersicht/) |

Native macOS also remains a valid aesthetic base: keep its menu bar, Dock, Spaces and gestures; deliberately choose wallpaper, terminal/browser/editor themes, music presentation, and perhaps one small widget or border. The floating Awesome95 example and the SF-based Mac example are reminders that replacing the whole shell is not the definition of ricing. The eventual direction can be unmistakably Mac and still visibly personal.

## Goodies beyond the usual CLI shopping list

| Goodie | Why it belongs in this investigation | Evidence and boundary |
|---|---|---|
| **Cliamp** | A Winamp-inspired terminal music player with radio, EQ and visualizer; music becomes part of the desktop's character | Official project supports macOS and documents media-key/Control Center integration. Candidate for the existing Ghostty; not tested here. [Project](https://github.com/bjarneo/cliamp), [media controls](https://github.com/bjarneo/cliamp/blob/main/docs/mediactl.md) |
| **A visible agent companion to the workspace** | Herdr/OpenCode in the cyberpunk Mac dots show that AI tools can share the terminal's visual world | Evidence of an author's configuration, not a decision to replace Codex. Use the existing AI comparison before selecting tools. [Mac dotfiles](https://github.com/gcodenowski/dotfiles/tree/f4f3dad0116d6d4b42fca156ea15b28053dbc960), [AI comparison](https://github.com/NickSeagull/dotfiles/blob/research/omarchy-ai/docs/research/omarchy-ai.md) |
| **One summoned shelf of controls** | Music, sound, battery, calendar, quick actions and an occasional AI question can feel like a coherent part of the machine | end-4 demonstrates the maximal version; SketchyBar popups or an existing launcher can provide smaller Mac interpretations. Avoid assuming a custom full-screen dashboard is necessary. [end-4](https://github.com/end-4/dots-hyprland), [SketchyBar popups](https://felixkratz.github.io/SketchyBar/config/popups) |
| **Useful images inside terminal tools** | File previews, cover art and a small visualizer add richness without opening another conventional app | DrConverse demonstrates LF/chafa; Cliamp supplies the music direction. Copy the capability only where it appeals; fetch output is optional decoration. [Nordic Mac post](https://www.reddit.com/r/unixporn/comments/1kndhaj/aerospace_functional_nordic_macos_setup_easy_for/), [Cliamp](https://github.com/bjarneo/cliamp) |
| **Playful desktop objects** | Radio globes, minesweeper and pets express the same hobby spirit as vintage docks and Conky | Omarchy community examples include [Radio Atlas](https://github.com/AksharP5/omarchy-radio-atlas), [Omasweeper](https://github.com/jankeesvw/omasweeper), and [Omagotchi](https://github.com/higgsfield-ai/omagotchi). These are community projects, not claims of stock Omarchy bundling or Mac compatibility. |

Capture also belongs to the feel of a finished machine: select a region, preview or annotate, and put it where expected with one familiar gesture. The qxb3 setup documents a themed Linux capture path; the [earlier Mac report](https://github.com/NickSeagull/dotfiles/blob/research/macos-desktop/docs/research/macos-desktop.md) records native Mac and Raycast options. This is a place to coordinate existing behavior before adding another capture utility.

## What the screenshots prove—and what they stage

Five distinctions keep the inspiration useful without draining the fun:

1. **Wallpaper exposure is a composition choice.** A centered terminal looks spectacular; a normal code/browser session may cover most of the artwork. Mellow demonstrates that a rice can also work visually when the screen is full.
2. **A fetch logo and Cava are ornaments.** They communicate palette and personality; they do not establish that the underlying desktop is better. Enjoying them is enough reason to keep them, but they need not become permanent chores.
3. **Every panel open is a showroom pose.** The end-4 and qxb3 images establish a cohesive set of controls. The ordinary resting state can be much quieter.
4. **Movement needs movement evidence.** Author-reported click animation, documented niri scrolling and a GIF still are different evidence. This notebook does not claim to have tested responsiveness or watched videos it could not access.
5. **A dotfiles repository evolves.** The Mellow screenshot is pinned; several Mac repository images are later revisions of their Reddit posts. Missing dependencies and author caveats matter when copying code, but do not invalidate their visual ideas.

## A visual direction can now start with examples

Impeccable can help compare palette relationships, type, density, shape, spacing and motion across **actual desktop scenes**: a populated screen, an empty desktop, a launcher, a small music/control popup. It need not produce a product brief, a new app shell or another interview about productivity.

Four promising directions are now grounded in examples: **soft and muted** (Mellow); **warm illustrated workstation** (the later Nordic Mac and Gruvbox); **graphic retro** (qxb3/Awesome95/Retro 82); **expressive controls and motion** (end-4, Noctalia/niri and tactile purple Mac). These can be mixed. A light paper/ink direction is also credible from Flexoki Light. No taste choice is made on Nick's behalf.

**Next action, under two minutes:** open the Mellow, retro pixel and end-4 pictures above side by side. A reaction as small as “more like this” is enough to guide the next visual comparison; no workflow narrative is required.
