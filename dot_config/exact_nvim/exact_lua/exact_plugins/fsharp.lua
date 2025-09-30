return {
  -- Ensure Mason doesn't auto-install F# tools
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      -- Ensure F# tools are not in the ensure_installed list
      if opts.ensure_installed then
        opts.ensure_installed = vim.tbl_filter(function(tool)
          return not vim.tbl_contains({
            "fsautocomplete",
            "fantomas",
            "fsharp-language-server",
            "netcoredbg",
          }, tool)
        end, opts.ensure_installed)
      end
    end,
  },

  -- Disable fsautocomplete LSP since we're using Ionide
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Explicitly disable fsautocomplete to prevent conflicts with Ionide
        fsautocomplete = {
          mason = false,
          autostart = false, -- This prevents the LSP from starting
        },
      },
    },
  },

  -- Ionide-vim for enhanced F# support (handles all LSP features)
  {
    "ionide/Ionide-vim",
    ft = { "fsharp" },
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = function()
      -- Enable Ionide's built-in LSP client
      vim.g["fsharp#lsp_auto_setup"] = 1
      vim.g["fsharp#automatic_workspace_init"] = 1
      vim.g["fsharp#automatic_reload_workspace"] = 1
      vim.g["fsharp#exclude_project_directories"] = { ".git" }
      vim.g["fsharp#workspace_mode_peek_deep_level"] = 2
      vim.g["fsharp#show_signature_on_cursor_move"] = 0 -- Disable to avoid duplicates with LazyVim
      vim.g["fsharp#lsp_codelens"] = 0                  -- Disable code lens to avoid "unresolved lens" issues

      -- Configure fsautocomplete path for Ionide
      vim.g["fsharp#fsautocomplete_command"] = { "fsautocomplete", "--adaptive-lsp-server-enabled" }

      -- Enable Fantomas formatting through Ionide
      vim.g["fsharp#fantomas_executable"] = "fantomas"
      vim.g["fsharp#fantomas_extra_args"] = ""

      -- Enable additional F# features
      vim.g["fsharp#fsi_command"] = "dotnet fsi"
      vim.g["fsharp#fsi_keymap"] = "custom"
      vim.g["fsharp#fsi_window_command"] = "botright 10new"

      -- F# specific keymaps
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "fsharp",
        callback = function()
          local opts = { buffer = true, silent = true }
          -- F# Interactive keymaps
          vim.keymap.set(
            "n",
            "<leader>fi",
            ":FsiShow<CR>",
            vim.tbl_extend("force", opts, { desc = "Show F# Interactive" })
          )
          vim.keymap.set(
            "n",
            "<leader>fq",
            ":FsiQuit<CR>",
            vim.tbl_extend("force", opts, { desc = "Quit F# Interactive" })
          )
          vim.keymap.set(
            "n",
            "<leader>fe",
            "<Plug>(FSharpSendLine)",
            vim.tbl_extend("force", opts, { desc = "Send line to FSI" })
          )
          vim.keymap.set(
            "v",
            "<leader>fe",
            "<Plug>(FSharpSendSelection)",
            vim.tbl_extend("force", opts, { desc = "Send selection to FSI" })
          )
          vim.keymap.set(
            "n",
            "<leader>fd",
            ":FSharpShowDeclaration<CR>",
            vim.tbl_extend("force", opts, { desc = "Show F# declaration" })
          )
        end,
      })
    end,
  },

  -- Tree-sitter support for F#
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "fsharp",
      })
    end,
  },

  -- Disable code lens for F# in LazyVim to prevent "unresolved lens" issues
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Disable code lens refresh for F# files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "fsharp",
        callback = function()
          -- Disable automatic code lens refresh
          vim.b.codelens_enabled = false
        end,
      })
      return opts
    end,
  },

  -- Configure formatting for F# files using conform.nvim (LazyVim's formatter)
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        fsharp = { "fantomas" },
      },
      formatters = {
        fantomas = {
          -- Fantomas formats files in place, doesn't support stdin/stdout
          command = function()
            local handle = io.popen("dotnet tool list 2>/dev/null | grep -q fantomas && echo 'found'")
            local result = handle:read("*a")
            handle:close()
            if result:match("found") then
              return "dotnet"
            else
              return "fantomas"
            end
          end,
          args = function(_, ctx)
            local handle = io.popen("dotnet tool list 2>/dev/null | grep -q fantomas && echo 'found'")
            local result = handle:read("*a")
            handle:close()
            if result:match("found") then
              -- When using dotnet tool
              return { "fantomas", ctx.filename }
            else
              -- When using fantomas directly
              return { ctx.filename }
            end
          end,
          stdin = false,
          tmpfile_format = false,
          exit_codes = { 0, 99 }, -- 99 means file was already formatted
        },
      },
    },
  },

  -- DAP support for F# debugging with netcoredbg
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "jay-babu/mason-nvim-dap.nvim",
        opts = function(_, opts)
          -- Exclude netcoredbg from Mason auto-install if using system version
          if opts.ensure_installed then
            opts.ensure_installed = vim.tbl_filter(function(tool)
              return tool ~= "netcoredbg"
            end, opts.ensure_installed)
          end
        end,
      },
    },
    opts = function()
      local dap = require("dap")
      if not dap.adapters.netcoredbg then
        dap.adapters.netcoredbg = {
          type = "executable",
          command = "netcoredbg",
          args = { "--interpreter=vscode" },
        }
      end
      for _, lang in ipairs({ "fsharp" }) do
        if not dap.configurations[lang] then
          dap.configurations[lang] = {
            {
              type = "netcoredbg",
              name = "Launch",
              request = "launch",
              program = function()
                return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/net9.0/", "file")
              end,
              cwd = "${workspaceFolder}",
              stopAtEntry = false,
            },
            {
              type = "netcoredbg",
              name = "Attach",
              request = "attach",
              processId = require("dap.utils").pick_process,
              cwd = "${workspaceFolder}",
            },
          }
        end
      end
    end,
  },

  -- Disable LSP progress notifications for F# to reduce noise
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      -- Add routes to filter out F# typechecking messages
      opts.routes = opts.routes or {}
      table.insert(opts.routes, {
        filter = {
          event = "lsp",
          kind = "progress",
          cond = function(message)
            local client = vim.tbl_get(message.opts, "progress", "client")
            -- Filter out Ionide/F# LSP progress messages
            return client and (client == "ionide" or client == "fsautocomplete" or client == "FSharp.Compiler.Service")
          end,
        },
        opts = { skip = true },
      })
      -- Also filter out messages containing "typechecking" or "parsing"
      table.insert(opts.routes, {
        filter = {
          event = "lsp",
          any = {
            { find = "typechecking" },
            { find = "Typechecking" },
            { find = "parsing" },
            { find = "Parsing" },
            { find = "FSharp.Compiler.Service" },
          },
        },
        opts = { skip = true },
      })
      return opts
    end,
  },
}
