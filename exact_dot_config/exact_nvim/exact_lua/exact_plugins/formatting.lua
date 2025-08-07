-- Prettier formatting configuration for JavaScript/TypeScript files
-- 
-- Prerequisites:
-- - Install prettier globally: npm install -g prettier
-- - Or install prettier in your project: npm install --save-dev prettier
-- - Or use nix/homebrew: nix-env -iA nixpkgs.prettier / brew install prettier
--
-- The formatter will automatically use the project's prettier if available,
-- otherwise it will fall back to the global installation.

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
      -- Enable format on save
      format_on_save = {
        -- Enable format on save
        timeout_ms = 500,
        lsp_fallback = true,
      },
      -- Configure formatters
      formatters = {
        prettier = {
          -- Use prettier from node_modules if available, otherwise use global
          command = function()
            local util = require("conform.util")
            local node_modules_prettier = util.find_executable({
              "node_modules/.bin/prettier",
            }, "prettier")
            if node_modules_prettier then
              return node_modules_prettier
            end
            return "prettier"
          end,
          args = { "--stdin-filepath", "$FILENAME" },
          stdin = true,
        },
      },
    },
  },
}