return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            -- Keep the workspace's repository container visible without
            -- revealing every ignored build output or dependency directory.
            include = { vim.env.HOME .. "/egregoreOS/repos" },
          },
        },
      },
    },
  },
}
