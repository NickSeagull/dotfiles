-- Prettier formatting configuration for JavaScript/TypeScript files
-- 
-- Prerequisites:
-- - Install prettier globally: npm install -g prettier
-- - Or install prettier in your project: npm install --save-dev prettier
-- - Or use nix/homebrew: nix-env -iA nixpkgs.prettier / brew install prettier
--
-- The formatter will automatically use the project's prettier if available,
-- otherwise it will fall back to the global installation.
--
-- LazyVim handles format on save automatically. Toggle with <leader>uf

return {
  -- Configure conform.nvim for formatting
  {
    "stevearc/conform.nvim",
    opts = {
      -- Define formatters by file type
      formatters_by_ft = {
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        markdown = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        yaml = { "prettier" },
      },
      -- Configure formatters
      formatters = {
        prettier = {
          -- Simpler configuration that should work with most setups
          prepend_args = { "--stdin-filepath", "$FILENAME" },
        },
      },
    },
  },
}