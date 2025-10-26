-- AstroJS configuration for Neovim
-- Provides LSP support, syntax highlighting, and tooling for Astro projects

return {
  -- Ensure Astro parser is installed for treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "astro",
        "tsx",
        "typescript",
        "javascript",
      })
    end,
  },

  -- Configure Astro language server
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        astro = {
          filetypes = { "astro" },
          init_options = {
            typescript = {
              -- Path to typescript SDK - defaults to bundled version
              -- tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib"
            },
          },
          settings = {
            astro = {
              -- Enable Astro language server features
              trace = {
                server = "off",
              },
            },
          },
          -- Ensure Astro files are recognized
          on_attach = function(client, bufnr)
            -- Disable formatting if you prefer prettier or other formatters
            -- client.server_capabilities.documentFormattingProvider = false
          end,
        },
      },
    },
  },

  -- Ensure astro-language-server is installed via Mason
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "astro-language-server",
        "prettier", -- For Astro file formatting
      })
    end,
  },

  -- Optional: Configure formatting for Astro files
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        astro = { "prettier" },
      },
    },
  },
}
