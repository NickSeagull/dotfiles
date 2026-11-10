# Neovim terminal background

Nick prefers Neovim to inherit the terminal's default background so Ghostty's
transparency remains visible. Keep Cyberdream's `transparent = true` alongside
the existing dark variant and scarlet accents. Use the theme's native option;
it also clears backgrounds for inactive windows, floats, gutters, and empty
buffer lines while preserving useful selection and cursor highlights.

After Home Manager activation, verify the effective `Normal`, `NormalNC`,
`NormalFloat`, `SignColumn`, and `EndOfBuffer` highlights have no explicit
background (`vim.api.nvim_get_hl(0, { name = group, link = false }).bg == nil`).
Refresh existing Neovim servers through RPC by loading the activated theme spec,
applying its Cyberdream options, and reselecting the colorscheme. Keep buffers
and sessions open.
