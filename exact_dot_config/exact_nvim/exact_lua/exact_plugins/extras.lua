return {
  { import = "lazyvim.plugins.extras.util.chezmoi" },
  { import = "lazyvim.plugins.extras.lang.kotlin" },
  { import = "lazyvim.plugins.extras.lang.omnisharp" },
  {
    "LazyVim/LazyVim",
    -- this runs *before* LazyVim calls :colorscheme
    opts = {
      colorscheme = function() end, -- <- disables themes
    },
  },
}
