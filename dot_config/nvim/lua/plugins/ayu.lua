-- since this is just an example spec, don't actually load anything here and return an empty spec

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  -- add gruvbox
  {
    "Shatur/neovim-ayu",
    config = function()
      require("ayu").setup({
        mirage = false,
        terminal = true,
        overrides = {},
      })
    end,
  },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "ayu",
    },
  },
}
