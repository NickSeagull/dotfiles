return {
  {
    "LazyVim/LazyVim",
    opts = {
      -- Let auto-dark-mode handle colorscheme selection
      colorscheme = function()
        -- This function will be called by LazyVim to set initial colorscheme
        -- We'll let our auto-dark-mode plugin handle it instead
      end,
    },
  },
}
