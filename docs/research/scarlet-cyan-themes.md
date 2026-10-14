# Existing themes for a scarlet and cyan macOS setup

Research date: 2026-10-14. Scope: Cyberdream, Doom One, and Cyberpunk Scarlet Protocol. This is a palette and application-port decision, not an installation plan. The target is charcoal `#17191D`, warm scarlet `#FF493D`, and teal-cyan `#2DD4BF`, with scarlet dominant, rounded surfaces, no dock, manual Moom drop zones, and keyboard window switching.

## Recommendation

**Use Cyberdream's default dark palette as the closest existing foundation.** Its charcoal is almost identical to the target; its red is warm coral rather than pink, and its cyan is unmistakably bright. This is a visual judgment from the actual palette values, not an upstream claim that the theme is scarlet-led. An unchanged Cyberdream terminal or editor still uses green, blue, purple, and yellow. Scarlet dominance must come from the wallpaper and the chosen interface accents. [Cyberdream palette source](https://github.com/scottmckendry/cyberdream.nvim/blob/main/lua/cyberdream/colors.lua).

The practical limitation is VS Code: this investigation verified no published Cyberdream extension. If a ready-made VS Code extension is mandatory, Doom One is the calmer fallback; Cyberpunk Scarlet Protocol supplies a stronger red-forward interface but its primary red is pinker than requested. Neither fallback exactly matches the custom three-color direction. [Doom One Marketplace listing](https://marketplace.visualstudio.com/items?itemName=L-Nafaryus.doom-one-theme), [Cyberpunk Marketplace listing](https://marketplace.visualstudio.com/items?itemName=max-SS.cyberpunk).

## Palette comparison

| Candidate | Main background | Red | Cyan or teal | Fit judgment |
| --- | --- | --- | --- | --- |
| Custom target | `#17191D` | `#FF493D` | `#2DD4BF` | Reference direction |
| Cyberdream default | `#16181A` | `#FF6E5E` | `#5EF1FF` | Closest neutral charcoal; warm red; brighter, bluer cyan |
| Doom One original | `#282C34` | `#FF6C6B` | `#46D9FF`; teal `#4DB5BD` | Lighter blue-gray; softer coral and teal |
| Cyberpunk Scarlet Protocol terminal port | `#101116` | `#FF0051`; bright `#FF6E67` | `#00C5C7`; bright `#60FDFF` | Dark neutral surface, but pink-red primary |

Values come from the [Cyberdream source palette](https://github.com/scottmckendry/cyberdream.nvim/blob/main/lua/cyberdream/colors.lua), [Doom One Emacs source](https://github.com/doomemacs/themes/blob/master/themes/doom-one-theme.el), and [Cyberpunk Scarlet Protocol Ghostty export](https://github.com/mbadolato/iTerm2-Color-Schemes/blob/master/ghostty/Cyberpunk%20Scarlet%20Protocol).

## Cyberdream: best palette, incomplete VS Code coverage

Cyberdream provides official exports for Ghostty, tmux, OpenCode, Zed, and other programs. Its Base16/Stylix export and Nix flake extras output make it particularly compatible with declarative dotfiles. VS Code is absent from the documented extras list. The documented saturation option defaults to full saturation; select the default variant rather than the muted variant for this brief. These are maintained application assets, not a macOS shell theme. [Cyberdream README and extras documentation](https://github.com/scottmckendry/cyberdream.nvim/blob/main/README.md).

The official Ghostty export reproduces the charcoal, warm red, and cyan directly. Its ordinary foreground and cursor are white, and its selection background is gray. Therefore a Cyberdream preview should show readable white terminal text with selective colored output, not a screen of red body text. [Official Ghostty export](https://github.com/scottmckendry/cyberdream.nvim/blob/main/extras/ghostty/cyberdream).

Targeted searches for Cyberdream plus VS Code and Marketplace surfaced an unfinished conversion gist with placeholder publisher and repository names. It is evidence of an attempted port, not proof of a released extension. No usable Marketplace identifier was verified; this does not establish that none exists anywhere. [Conversion author's original gist](https://gist.github.com/eevmanu/73a1b383b1d4253572b6615edea3d341).

## Doom One: available editor port, less vivid overall

The original Doom One source identifies Atom One Dark as its inspiration. Its highlight and keywords use blue, functions use magenta, strings use green, and red mainly signals errors, deletions, and selected language constructs. This makes its overall character less scarlet-forward than the requested desktop. The published VS Code port is `L-Nafaryus.doom-one-theme`; its listing explicitly names C++, Python, JSON, and Markdown support and notes that some languages may need semantic-colorization extensions. [Original theme](https://github.com/doomemacs/themes/blob/master/themes/doom-one-theme.el), [Port author's Marketplace listing](https://marketplace.visualstudio.com/items?itemName=L-Nafaryus.doom-one-theme).

Port drift matters: Ghostty's bundled Doom One assigns ANSI cyan to `#51AFEF`, which is the original Emacs palette's blue. It does not use the original `#46D9FF` cyan. The same theme name is insufficient to guarantee matching color roles across apps. The upstream export matches the locally inspected `/Applications/Ghostty.app/Contents/Resources/ghostty/themes/Doom One`. [Ghostty-format Doom One source](https://github.com/mbadolato/iTerm2-Color-Schemes/blob/master/ghostty/Doom%20One).

## Scarlet Protocol: real VS Code variant, misleading warm-red name

Cyberpunk's extension manifest contributes **Activate SCARLET protocol (beta)** under publisher `max-SS`. The variant is a real part of the published extension. [Extension manifest](https://github.com/prometheux-ar/cyberpunk/blob/master/package.json), [Marketplace listing](https://marketplace.visualstudio.com/items?itemName=max-SS.cyberpunk).

Its VS Code source uses editor background `#101116`, pink-red `#FF0055` for much of the interface, and green-cyan `#00FFC8` for cursor and several accents. Syntax remains multicolored. This is the strongest ready-made red-forward interface of the three, but warm scarlet would require overrides. [Scarlet variant source](https://github.com/prometheux-ar/cyberpunk/blob/master/themes/cyberpunk-scarlet-color-theme.json).

The locally bundled **Cyberpunk Scarlet Protocol** terminal theme has charcoal background but pink-red ordinary foreground `#E41951`. The separately named **Scarlet Protocol** has purple background `#1C153D`. Select by inspected values, not by name. [Cyberpunk terminal export](https://github.com/mbadolato/iTerm2-Color-Schemes/blob/master/ghostty/Cyberpunk%20Scarlet%20Protocol); local primary evidence: the two named files under `/Applications/Ghostty.app/Contents/Resources/ghostty/themes/`.

## What the palette decision actually delivers

A color theme supplies application colors; it does not establish rounded desktop widgets, Moom layouts, keyboard switching, or a browser skin. VS Code's own documentation defines its theme scope as editor and workbench colors and offers separate customization settings. Accordingly, a faithful next preview should use Cyberdream charcoal, warm red, and bright cyan while showing the requested desktop composition separately. Calling that an existing palette with coordinated styling is accurate; claiming one theme installs the entire Mac appearance is unsupported. [VS Code theme documentation](https://code.visualstudio.com/docs/configure/themes).
