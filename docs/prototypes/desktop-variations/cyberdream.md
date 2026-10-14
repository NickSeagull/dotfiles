# Cyberdream as the existing theme foundation

**Chosen theme:** Cyberdream's default dark palette with the red accent overridden to `#FF493D`. Nick explicitly chose this version after viewing the regenerated screenshots. Keep upstream cyan `#5EF1FF`, neutral charcoal surfaces and the remaining palette. He liked the original scarlet/cyan direction and rejected Catppuccin and Gruvbox as too subdued.

The [primary-source research](https://github.com/NickSeagull/dotfiles/blob/research/scarlet-cyan-themes/docs/research/scarlet-cyan-themes.md) compares Cyberdream, Doom One and Cyberpunk Scarlet Protocol. Cyberdream is closest in palette: neutral charcoal, warm red and bright cyan. This judgment is based on source values, not a promise that a theme supplies an entire macOS shell.

## Existing Cyberdream palette

![Cyberdream default palette desktop concept](assets/cyberdream-stock.png)

Source colors: base `#16181A`, elevated surface `#1E2124`, foreground `#FFFFFF`, warm red `#FF6E5E`, cyan `#5EF1FF`. The screenshot illustrates those colors in the already chosen modern rounded desktop composition, with scarlet wallpaper and red given the main accent role. Cyberdream itself is a multicolor syntax/terminal theme; this red-forward desktop treatment is a proposed adaptation.

## Cyberdream with scarlet accent

![Cyberdream with scarlet accent override desktop concept](assets/cyberdream-scarlet.png)

Keep the same upstream background, foreground, cyan and other colors; replace the primary red with `#FF493D`. This is explicitly customized Cyberdream, not the unchanged upstream palette. Nick selected this as the theme foundation.

The renders approximate palette values. They preserve the composition rather than establish pixel-exact app themes, implementation syntax, or live system state. The depicted editor, browser and control surfaces are concept treatments. Moom drop zones, keyboard switching and no app dock remain the agreed interaction constraints.

## What can be reused

Cyberdream directly supports Neovim and provides official Ghostty, tmux, OpenCode and other exports, as well as Nix extras outputs. Nick said VS Code coverage is not important and he will probably switch back to Neovim. Record Neovim as his likely editor preference, not a finalized migration or plugin-manager choice. A published usable VS Code Cyberdream extension was not verified; that gap no longer blocks this theme choice. The browser, bar, wallpaper, and desktop popups still need coordinated styling. [Upstream palette](https://github.com/scottmckendry/cyberdream.nvim/blob/main/lua/cyberdream/colors.lua), [official extras](https://github.com/scottmckendry/cyberdream.nvim/blob/main/README.md).

## Proposed Neovim theme configuration

```lua
require("cyberdream").setup({
  variant = "default",
  transparent = false,
  colors = { red = "#ff493d" },
})
vim.cmd.colorscheme("cyberdream")
```

This is a draft of the theme settings, not an installed configuration. The existing generated Ghostty theme and other exports would need the same red override so the desktop does not drift between stock coral and chosen scarlet. Keep a single documented override shared across the chosen surfaces. [Upstream configuration API](https://github.com/scottmckendry/cyberdream.nvim/blob/main/README.md).

## Provenance

Both previews were generated with the built-in image tool, using Impeccable color/composition guidance and the [original custom concept](assets/custom-scarlet-teal.png) as the edit reference. The exact prompts are saved in [cyberdream-prompts.json](cyberdream-prompts.json). No comparison viewer was created; Nick explicitly declined one. No software was installed or activated.

Next: translate the chosen theme into the terminal, editor, bar, wallpaper and summoned controls during implementation planning.
