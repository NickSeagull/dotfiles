return {
  -- Add Haskell treesitter parser for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "haskell" },
    },
  },

  -- Ensure Mason doesn't auto-install Haskell tools
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      -- Ensure haskell tools are not in the ensure_installed list
      if opts.ensure_installed then
        opts.ensure_installed = vim.tbl_filter(function(tool)
          return not vim.tbl_contains({
            "haskell-language-server",
            "fourmolu",
            "hlint",
            "haskell-debug-adapter",
            "haskell-ghcid",
          }, tool)
        end, opts.ensure_installed)
      end
    end,
  },

  -- Configure LSP to use Nix-provided HLS
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        hls = {
          mason = false, -- Don't install via Mason
          cmd = { "haskell-language-server", "--lsp" },
          filetypes = { "haskell", "lhaskell" },
          root_dir = function(fname)
            -- Use lspconfig's built-in root pattern detection
            return require("lspconfig.util").root_pattern("*.cabal", "stack.yaml", "cabal.project", "package.yaml",
              "hie.yaml", ".git")(fname)
          end,
          settings = {
            haskell = {
              -- Use whatever formatter is available in PATH (fourmolu, ormolu, etc.)
              formattingProvider = "fourmolu",
              -- Disable hlint if you want to use your own version
              checkProject = true,
            },
          },
        },
      },
      setup = {
        hls = function(_, opts)
          -- Additional setup to ensure we're using the system HLS
          local lspconfig = require("lspconfig")
          lspconfig.hls.setup(opts)
          return true -- Return true to prevent LazyVim from calling setup
        end,
      },
    },
  },

  -- Optional: Add Haskell-specific plugins that work well with Nix
  {
    "mrcjkb/haskell-tools.nvim",
    enabled = false, -- Disable if you prefer simple LSP setup
  },
}
