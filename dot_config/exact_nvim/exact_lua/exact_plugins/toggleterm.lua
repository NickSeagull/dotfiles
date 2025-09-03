return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = 20,
      -- Use <c-\> as the primary toggle mapping (less likely to conflict)
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      persist_mode = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      auto_scroll = true,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    },
    keys = {
      -- Multiple keybinding options for flexibility
      { "<c-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
      { "<c-\\>", "<cmd>ToggleTerm<cr>", mode = "t", desc = "Toggle terminal" },
      { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Toggle vertical terminal" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Toggle horizontal terminal" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle floating terminal" },
      -- Alternative keybindings
      { "<A-i>", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal (Alt)" },
      { "<A-i>", "<cmd>ToggleTerm<cr>", mode = "t", desc = "Toggle terminal (Alt)" },
    },
  },
}