return {
  -- Auto dark mode detection for macOS
  {
    "f-person/auto-dark-mode.nvim",
    enabled = vim.fn.has("mac") == 1,
    lazy = false,
    priority = 1000,
    opts = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.api.nvim_set_option("background", "dark")
        vim.cmd("colorscheme freshcut-contrast")
      end,
      set_light_mode = function()
        vim.api.nvim_set_option("background", "light")
        vim.cmd("colorscheme PaperColor")
      end,
    },
    config = function(_, opts)
      -- Check if we're in an SSH session
      local is_ssh = vim.env.SSH_CLIENT ~= nil or vim.env.SSH_TTY ~= nil
      
      if is_ssh then
        -- Always use light mode in SSH sessions
        vim.api.nvim_set_option("background", "light")
        vim.cmd("colorscheme PaperColor")
      else
        -- Use auto-dark-mode on local macOS
        require("auto-dark-mode").setup(opts)
      end
    end,
  },
}