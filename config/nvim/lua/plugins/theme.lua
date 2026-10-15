return {
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      variant = "default",
      transparent = false,
      colors = { red = "#FF493D" },
      highlights = {
        FloatBorder = { fg = "#FF493D" },
        WinSeparator = { fg = "#FF493D" },
        CursorLineNr = { fg = "#FF493D", bold = true },
        TabLineSel = { fg = "#16181A", bg = "#FF493D", bold = true },
        SnacksPickerTitle = { fg = "#FF493D", bold = true },
        SnacksDashboardHeader = { fg = "#FF493D" },
      },
    },
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "cyberdream" } },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local theme = require("lualine.themes.auto")
      theme.normal.a.bg = "#FF493D"
      opts.options.theme = theme
    end,
  },
}
