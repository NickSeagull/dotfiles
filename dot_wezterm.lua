-- WezTerm configuration — matching Ghostty + Zellij-style multiplexing
-- Bloodcode theme (red-toned hacker theme)
local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- ── Shell ───────────────────────────────────────────────────
-- WezTerm defaults to cmd.exe on Windows; use PowerShell instead
config.default_prog = { "powershell.exe" }

-- ── Font ────────────────────────────────────────────────────
-- Matches Ghostty: font-family = IosevkaTerm Nerd Font, font-size = 16
-- On Windows, Nerd Font Mono variant is registered as "Iosevka Nerd Font Mono"
config.font = wezterm.font("Iosevka Nerd Font Mono")
config.font_size = 14.0

-- Matches Ghostty: font-feature = +ss01..+ss09, +liga, +calt
config.harfbuzz_features = {
  "ss01", "ss02", "ss03", "ss04", "ss05",
  "ss06", "ss07", "ss08", "ss09",
  "liga", "calt",
}

-- Antialiased rendering with no hinting for smooth glyphs
config.freetype_load_target = "Light"
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

-- Matches Ghostty: term = xterm-256color
config.term = "xterm-256color"

-- Don't nag
config.check_for_updates = false

-- ── Multiplexer ─────────────────────────────────────────────
-- WezTerm replaces Zellij on Windows — built-in splits/tabs
-- Tab bar: bottom, minimal, hidden when only one tab
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 32

-- ── Leader Key: Ctrl+g ──────────────────────────────────────
-- Mirrors Zellij: Ctrl+g enters command layer, single key executes, back to normal
config.leader = { key = "g", mods = "CTRL", timeout_milliseconds = 1000 }

-- ── Keybindings ─────────────────────────────────────────────
-- Designed so kanata z-mode shortcuts work identically to Zellij.
--
-- Kanata z-mode sends:          WezTerm action:
--   z+h/j/k/l → Alt+hjkl       pane navigation
--   z+y/u/i/o → Alt+Shift+hjkl pane resize (Zellij=move, WezTerm=resize)
--   z+n       → Alt+n           new pane (split right)
--   z+=/-     → Alt+=/Alt+-     resize panes
--   z+p       → Alt+p           tab/workspace switcher
--   z+space   → Ctrl+g          leader key (command layer)
--
-- Then Ctrl+g (leader) sub-keys mirror Zellij's command layer:
--   s = split down    v = split right    n = new pane
--   x = close pane    f = fullscreen     w = tab switcher
--   h/j/k/l = navigate panes    t = new tab    1-9 = jump to tab
--   q = quit

config.keys = {
  -- ── Alt+hjkl: pane navigation (always available) ────────
  -- Kanata z+h/j/k/l sends Alt+h/j/k/l
  { key = "h", mods = "ALT", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "ALT", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "ALT", action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "ALT", action = act.ActivatePaneDirection("Right") },

  -- ── Alt+Shift+hjkl: resize panes (always available) ────
  -- Kanata z+y/u/i/o sends Alt+Shift+h/j/k/l
  -- Zellij uses these for move-pane; WezTerm maps to resize instead
  { key = "h", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
  { key = "j", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
  { key = "k", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
  { key = "l", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },

  -- ── Alt+n: new pane (always available) ──────────────────
  -- Kanata z+n sends Alt+n
  { key = "n", mods = "ALT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

  -- ── Alt+=/Alt+-: resize panes (always available) ────────
  -- Kanata z+=/z+- sends Alt+=/Alt+-
  { key = "=", mods = "ALT", action = act.AdjustPaneSize({ "Right", 5 }) },
  { key = "-", mods = "ALT", action = act.AdjustPaneSize({ "Left", 5 }) },

  -- ── Alt+p: tab/workspace switcher (always available) ────
  -- Kanata z+p sends Alt+p (Zellij session manager equivalent)
  { key = "p", mods = "ALT", action = act.ShowLauncherArgs({ flags = "FUZZY|TABS|WORKSPACES" }) },

  -- ── Leader (Ctrl+g) → split ─────────────────────────────
  -- Mirrors Zellij: Ctrl+g → s (split down), v (split right)
  { key = "s", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

  -- ── Leader (Ctrl+g) → pane actions ──────────────────────
  { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = false }) },
  { key = "f", mods = "LEADER", action = act.TogglePaneZoomState },
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

  -- ── Leader (Ctrl+g) → pane navigation ───────────────────
  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

  -- ── Leader (Ctrl+g) → tab management ────────────────────
  { key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "n", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|TABS|WORKSPACES" }) },
  { key = "q", mods = "LEADER", action = act.QuitApplication },

  -- ── Leader (Ctrl+g) → jump to tab by number ────────────
  { key = "1", mods = "LEADER", action = act.ActivateTab(0) },
  { key = "2", mods = "LEADER", action = act.ActivateTab(1) },
  { key = "3", mods = "LEADER", action = act.ActivateTab(2) },
  { key = "4", mods = "LEADER", action = act.ActivateTab(3) },
  { key = "5", mods = "LEADER", action = act.ActivateTab(4) },
  { key = "6", mods = "LEADER", action = act.ActivateTab(5) },
  { key = "7", mods = "LEADER", action = act.ActivateTab(6) },
  { key = "8", mods = "LEADER", action = act.ActivateTab(7) },
  { key = "9", mods = "LEADER", action = act.ActivateTab(8) },
}

-- ── Bloodcode Color Scheme ──────────────────────────────────
-- Matches Ghostty theme: dot_config/ghostty/themes/bloodcode
config.colors = {
  foreground = "#ff6270",
  background = "#0e0a0a",

  cursor_fg = "#0e0a0a",
  cursor_bg = "#ff2e3a",

  selection_fg = "#ff6270",
  selection_bg = "#2a1b1e",

  -- Tab bar (bloodcode-tinted)
  tab_bar = {
    background = "#0e0a0a",
    active_tab = {
      bg_color = "#2a1b1e",
      fg_color = "#ff6270",
      intensity = "Bold",
    },
    inactive_tab = {
      bg_color = "#130d0e",
      fg_color = "#a3918c",
    },
    inactive_tab_hover = {
      bg_color = "#1c1214",
      fg_color = "#ff6270",
    },
    new_tab = {
      bg_color = "#0e0a0a",
      fg_color = "#a3918c",
    },
    new_tab_hover = {
      bg_color = "#2a1b1e",
      fg_color = "#ff2e3a",
    },
  },

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
