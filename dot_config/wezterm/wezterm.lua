-- WezTerm configuration — matching Ghostty settings
-- Bloodcode theme (red-toned hacker theme)
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ── Font ────────────────────────────────────────────────────
-- Matches Ghostty: font-family = IosevkaTerm Nerd Font, font-size = 16
config.font = wezterm.font("IosevkaTerm Nerd Font")
config.font_size = 16.0

-- Matches Ghostty: font-feature = +ss01..+ss09, +liga, +calt
config.harfbuzz_features = {
  "ss01", "ss02", "ss03", "ss04", "ss05",
  "ss06", "ss07", "ss08", "ss09",
  "liga", "calt",
}

-- Matches Ghostty: freetype-load-flags = no-hinting,monochrome
config.freetype_load_target = "Mono"
config.freetype_load_flags = "NO_HINTING"

-- ── Window ──────────────────────────────────────────────────
-- Matches Ghostty: window-width = 80, window-height = 25
config.initial_cols = 80
config.initial_rows = 25

-- Matches Ghostty: window-padding-x = 24, window-padding-y = 24
config.window_padding = {
  left = 24,
  right = 24,
  top = 24,
  bottom = 24,
}

-- Matches Ghostty: macos-titlebar-style = hidden (hides titlebar on all platforms)
config.window_decorations = "RESIZE"

-- Matches Ghostty: background-opacity = 1
config.window_background_opacity = 1.0

-- Matches Ghostty: quit-after-last-window-closed = true
config.window_close_confirmation = "NeverPrompt"

-- No tab bar — using Zellij for multiplexing
config.enable_tab_bar = false

-- Matches Ghostty: term = xterm-256color
config.term = "xterm-256color"

-- Don't nag
config.check_for_updates = false

-- ── Bloodcode Color Scheme ──────────────────────────────────
-- Matches Ghostty theme: dot_config/ghostty/themes/bloodcode
config.colors = {
  foreground = "#ff6270",
  background = "#0e0a0a",

  cursor_fg = "#0e0a0a",
  cursor_bg = "#ff2e3a",

  selection_fg = "#ff6270",
  selection_bg = "#2a1b1e",

  -- ANSI Normal (0-7)
  ansi = {
    "#0e0a0a", -- black
    "#ff2e3a", -- red
    "#c21c28", -- green
    "#ffaf00", -- yellow
    "#bf4bff", -- blue
    "#ff70c7", -- magenta
    "#f6c524", -- cyan
    "#e8bfbf", -- white
  },

  -- ANSI Bright (8-15)
  brights = {
    "#a3918c", -- bright black
    "#ff6270", -- bright red
    "#ffa83d", -- bright green
    "#ffe657", -- bright yellow
    "#30e5ff", -- bright blue
    "#ff9bdb", -- bright magenta
    "#ffaf00", -- bright cyan
    "#fff0ee", -- bright white
  },
}

return config
