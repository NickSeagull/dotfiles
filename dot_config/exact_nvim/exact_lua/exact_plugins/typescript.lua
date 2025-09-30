-- TypeScript/JavaScript LSP configuration
-- LazyVim uses vtsls by default, but you can switch to tsserver or typescript-tools if preferred

return {
  -- Ensure TypeScript parser is installed for treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "javascript",
        "typescript",
        "tsx",
        "jsdoc",
      })
    end,
  },

  -- Configure vtsls (default) or tsserver
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- vtsls is the default in LazyVim, providing better performance
        vtsls = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 30,
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "all" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
              -- Increase memory for large projects
              tsserver = {
                maxTsServerMemory = 8192,
              },
            },
            javascript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "all" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
        },
        -- tsserver and ts_ls are disabled by default in favor of vtsls
        tsserver = {
          enabled = false,
        },
        ts_ls = {
          enabled = false,
        },
      },
      setup = {
        vtsls = function(_, opts)
          -- Additional setup for vtsls if needed
        end,
      },
    },
  },

  -- Optional: typescript-tools.nvim as an alternative
  -- Uncomment if you prefer typescript-tools over vtsls
  -- {
  --   "pmizio/typescript-tools.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  --   opts = {},
  -- },

  -- Ensure vtsls is installed via Mason
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "vtsls",
        "typescript-language-server",
        "eslint-lsp",
      })
    end,
  },
}

