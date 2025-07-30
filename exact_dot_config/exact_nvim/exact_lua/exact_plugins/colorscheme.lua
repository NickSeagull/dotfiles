return {
  -- PaperColor theme for high contrast light mode
  {
    "NLKNguyen/papercolor-theme",
    lazy = false,
    priority = 1000,
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
            }
          }
        }
      }
      
      -- Set light background and apply colorscheme
      vim.o.background = "light"
      vim.cmd.colorscheme("PaperColor")
    end,
  },
}