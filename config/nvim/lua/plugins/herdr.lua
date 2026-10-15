return {
  {
    "ChmaraX/herdr-nvim",
    lazy = false,
    -- Herdr's sidebar calls setup() again on VimEnter. Let lazy.nvim own the
    -- mappings so repeated setup does not warn about existing <leader>a keys.
    opts = { keymaps = false },
    keys = {
      { "<leader>ac", function() require("herdr-nvim").comment_line() end, desc = "herdr-nvim: comment line" },
      { "<leader>ac", function() require("herdr-nvim").comment_selection() end, mode = "x", desc = "herdr-nvim: comment selection" },
      { "<leader>al", function() require("herdr-nvim").list_comments() end, desc = "herdr-nvim: list comments" },
      { "<leader>as", function() require("herdr-nvim").send_all({ submit = false }) end, desc = "herdr-nvim: paste comments to agent" },
      { "<leader>aS", function() require("herdr-nvim").send_all({ submit = true }) end, desc = "herdr-nvim: send comments to agent" },
      { "<leader>ai", function() require("herdr-nvim").ref_line() end, desc = "herdr-nvim: reference line at agent cursor" },
      { "<leader>ai", function() require("herdr-nvim").ref_selection() end, mode = "x", desc = "herdr-nvim: reference selection at agent cursor" },
    },
  },
}
