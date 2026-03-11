return {
  {
    "nickjvandyke/opencode.nvim",
    version = "*",
    dependencies = {
      {
        "folke/snacks.nvim",
        optional = true,
        opts = {
          input = {},
          picker = {
            actions = {
              opencode_send = function(...) return require("opencode").snacks_picker_send(...) end,
            },
            win = {
              input = {
                keys = {
                  ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
                },
              },
            },
          },
        },
      },
    },
    keys = {
      { "<leader>oa", function() require("opencode").ask("@this: ", { submit = true }) end, desc = "Ask opencode", mode = { "n", "x" } },
      { "<leader>os", function() require("opencode").select() end, desc = "Select opencode action", mode = { "n", "x" } },
      { "<leader>oo", function() require("opencode").toggle() end, desc = "Toggle opencode", mode = { "n", "t" } },
      { "<leader>or", function() return require("opencode").operator("@this ") end, desc = "Add range to opencode", mode = { "n", "x" }, expr = true },
      { "<leader>ol", function() return require("opencode").operator("@this ") .. "_" end, desc = "Add line to opencode", expr = true },
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {}
      vim.o.autoread = true
    end,
  },
}