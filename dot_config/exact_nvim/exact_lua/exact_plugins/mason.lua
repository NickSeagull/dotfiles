return {
  -- Disable Mason's automatic installation behavior
  {
    "mason-org/mason.nvim",
    opts = {
      -- Don't automatically install missing servers
      automatic_installation = false,
      -- Optional: completely disable the UI if you never want to use Mason
      ui = {
        check_outdated_packages_on_open = false,
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- Disable mason-lspconfig's automatic setup
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      -- Don't automatically install servers that are configured
      automatic_installation = false,
      -- Ensure nothing is auto-installed
      ensure_installed = {},
    },
  },

  -- Configure nvim-lspconfig to use system tools
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Disable automatic server setup by mason-lspconfig
      autoformat = true,
      setup = {
        -- Default setup function that prevents Mason from taking over
        ["*"] = function(server, opts)
          -- Only setup servers that don't have mason = false
          if opts.mason ~= false then
            return false -- Let LazyVim handle it normally
          end
          -- For servers with mason = false, we handle setup ourselves
          require("lspconfig")[server].setup(opts)
          return true
        end,
      },
    },
  },
}

