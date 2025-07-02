return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      hls = {
        mason = false,
        cmd = { "haskell-language-server-wrapper", "--lsp" },
        -- optional: any hls-specific settings here
      },
    },
  },
}
