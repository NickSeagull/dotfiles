return {
  -- PaperColor theme for high contrast light mode
  {
    "NLKNguyen/papercolor-theme",
    lazy = false,
    priority = 900, -- Lower priority so auto-dark-mode loads first
    config = function()
      -- Set PaperColor options for higher contrast
      vim.g.PaperColor_Theme_Options = {
        theme = {
          ["default.light"] = {
            override = {
              -- Increase contrast by making background pure white
              color00 = { "#ffffff", "255" },
              -- Make line numbers background lighter
              linenumber_bg = { "#f5f5f5", "255" },
              -- Stronger cursor line
              cursorline = { "#e0e0e0", "254" },
              -- Higher contrast visual selection
              visual_bg = { "#c0c0c0", "250" },
              -- Darker comments for better readability
              color08 = { "#5f5f5f", "241" },
            },
          },
        },
      }

      -- Only set default theme if auto-dark-mode is not handling it
      local is_wsl = vim.env.WSLENV ~= nil
      local is_ssh = vim.env.SSH_CLIENT ~= nil or vim.env.SSH_TTY ~= nil
      -- local is_mac = vim.fn.has("mac") == 1

      if is_ssh and not is_wsl then
        -- Default to light mode for SSH or non-macOS
        vim.opt.termguicolors = false -- honour the terminal palette
        vim.o.background = "light"
        vim.cmd.colorscheme("PaperColor")
      end
    end,
  },
  -- Tokyo Night theme for dark mode
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 900,
    opts = {
      style = "night",
    },
  },
}
