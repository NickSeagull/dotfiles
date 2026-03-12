-- Seamless Alt+hjkl navigation between neovim splits and tmux panes
-- Mirrors the always-available Alt+hjkl from the tmux config
return {
  "christoomey/vim-tmux-navigator",
  lazy = false,
  init = function()
    -- Use Alt+hjkl instead of default Ctrl+hjkl
    vim.g.tmux_navigator_no_mappings = 1
  end,
  keys = {
    { "<M-h>", "<cmd>TmuxNavigateLeft<cr>",  desc = "Navigate left (vim/tmux)" },
    { "<M-j>", "<cmd>TmuxNavigateDown<cr>",  desc = "Navigate down (vim/tmux)" },
    { "<M-k>", "<cmd>TmuxNavigateUp<cr>",    desc = "Navigate up (vim/tmux)" },
    { "<M-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate right (vim/tmux)" },
  },
}
