-- Python language support configuration
-- Comprehensive setup for Python development with uv, ruff, and pyright

return {
  -- Ensure Python parser is installed for treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "python",
        "toml",
        "rst",
      })
    end,
  },

  -- Configure pyright and ruff LSPs
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Pyright configuration
        pyright = {
          capabilities = (function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
            return capabilities
          end)(),
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                typeCheckingMode = "standard",
                -- Let ruff handle these
                autoImportCompletions = true,
                diagnosticSeverityOverrides = {
                  reportUnusedImport = "none",
                  reportUnusedVariable = "none",
                  reportUnusedClass = "none",
                  reportUnusedFunction = "none",
                },
              },
              -- Support for uv
              venvPath = vim.fn.expand("~/.cache/uv/python"),
            },
            pyright = {
              -- Using Ruff's import organizer
              disableOrganizeImports = true,
            },
          },
          -- Detect virtual environment
          on_attach = function(client, bufnr)
            -- Try to detect uv virtual environment
            local uv_venv = vim.fn.getcwd() .. "/.venv"
            local uv_python = uv_venv .. "/bin/python"
            if vim.fn.isdirectory(uv_venv) == 1 and vim.fn.filereadable(uv_python) == 1 then
              client.config.settings.python.pythonPath = uv_python
              client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
            end
          end,
        },
        -- Ruff configuration
        ruff = {
          cmd_env = { RUFF_TRACE = "messages" },
          init_options = {
            settings = {
              logLevel = "error",
              -- Ruff configuration
              lint = {
                enable = true,
                preview = true,
              },
              format = {
                enable = true,
                preview = true,
              },
              -- Auto-fix on save
              fixAll = true,
              organizeImports = true,
            },
          },
          -- Disable hover in favor of pyright
          on_attach = function(client, _)
            client.server_capabilities.hoverProvider = false
          end,
        },
      },
    },
  },

  -- Ensure Python tools are installed via Mason
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "pyright",
        "ruff",
        "ruff-lsp",
        "debugpy",
        "black", -- Fallback formatter
        "mypy", -- Type checker
      })
    end,
  },

  -- Configure conform for Python formatting
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        python = function(bufnr)
          if vim.fn.filereadable(vim.fn.getcwd() .. "/ruff.toml") == 1
            or vim.fn.filereadable(vim.fn.getcwd() .. "/pyproject.toml") == 1 then
            return { "ruff_fix", "ruff_format", "ruff_organize_imports" }
          end
          return { "ruff_format", "ruff_fix" }
        end,
      },
      formatters = {
        ruff_fix = {
          command = "ruff",
          args = {
            "check",
            "--fix",
            "--exit-zero",
            "--stdin-filename",
            "$FILENAME",
            "-",
          },
          stdin = true,
        },
        ruff_format = {
          command = "ruff",
          args = {
            "format",
            "--stdin-filename",
            "$FILENAME",
            "-",
          },
          stdin = true,
        },
        ruff_organize_imports = {
          command = "ruff",
          args = {
            "check",
            "--select=I",
            "--fix",
            "--exit-zero",
            "--stdin-filename",
            "$FILENAME",
            "-",
          },
          stdin = true,
        },
      },
    },
  },

  -- Python test support with neotest
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-python",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
    },
    opts = function(_, opts)
      opts = opts or {}
      opts.adapters = opts.adapters or {}
      opts.adapters["neotest-python"] = {
        dap = { justMyCode = false },
        -- Automatically detect test runner
        runner = function()
          local runners = { "pytest", "unittest" }
          for _, runner in ipairs(runners) do
            if vim.fn.executable(runner) == 1 then
              return runner
            end
            -- Check in virtual environment
            local venv_runner = vim.fn.getcwd() .. "/.venv/bin/" .. runner
            if vim.fn.filereadable(venv_runner) == 1 then
              return venv_runner
            end
          end
          return "pytest" -- Default
        end,
        args = { "--tb=short", "-vv" },
        -- Support for uv managed environments
        python = function()
          local uv_python = vim.fn.getcwd() .. "/.venv/bin/python"
          if vim.fn.filereadable(uv_python) == 1 then
            return uv_python
          end
          return "python"
        end,
      }
      return opts
    end,
    keys = {
      { "<leader>tn", function() require("neotest").run.run() end, desc = "Run Nearest Test" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run Test File" },
      { "<leader>td", function() require("neotest").run.run({strategy = "dap"}) end, desc = "Debug Nearest Test" },
      { "<leader>ts", function() require("neotest").run.stop() end, desc = "Stop Test" },
      { "<leader>ta", function() require("neotest").run.attach() end, desc = "Attach to Test" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Test Output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Test Output Panel" },
      { "<leader>tS", function() require("neotest").summary.toggle() end, desc = "Toggle Test Summary" },
    },
  },

  -- DAP support for Python debugging
  {
    "mfussenegger/nvim-dap-python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    ft = "python",
    config = function()
      local path = require("mason-registry").get_package("debugpy"):get_install_path()
      require("dap-python").setup(path .. "/venv/bin/python")

      -- Configure test debugging
      require("dap-python").test_runner = "pytest"

      -- Support for uv environments
      local dap = require("dap")
      dap.configurations.python = vim.list_extend(dap.configurations.python or {}, {
        {
          type = "python",
          request = "launch",
          name = "Launch file (uv)",
          program = "${file}",
          pythonPath = function()
            local uv_python = vim.fn.getcwd() .. "/.venv/bin/python"
            if vim.fn.filereadable(uv_python) == 1 then
              return uv_python
            end
            return "python"
          end,
        },
      })
    end,
  },

  -- Virtual environment selector
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
    },
    ft = "python",
    opts = {
      settings = {
        options = {
          enable_cached_venvs = true,
          cached_venv_automatic_activation = true,
          notify_user_on_venv_activation = true,
        },
        search = {
          -- Support for uv virtual environments
          root = {
            ".venv",
            ".cache/uv/python",
          },
          file_names = {
            "pyproject.toml",
            "requirements.txt",
            "setup.py",
            "Pipfile",
          },
        },
      },
    },
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
      { "<leader>cV", "<cmd>VenvSelectCached<cr>", desc = "Select Cached VirtualEnv" },
    },
  },

  -- Additional keymaps for Python development
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>py", group = "python" },
        { "<leader>pyt", "<cmd>!python -m pytest<cr>", desc = "Run pytest" },
        { "<leader>pyu", "<cmd>!uv sync<cr>", desc = "UV sync" },
        { "<leader>pyi", "<cmd>!uv pip install -r requirements.txt<cr>", desc = "UV install requirements" },
        { "<leader>pyr", "<cmd>!uv run python %<cr>", desc = "Run current file with uv" },
        { "<leader>pyl", "<cmd>!ruff check --fix %<cr>", desc = "Ruff fix current file" },
        { "<leader>pyf", "<cmd>!ruff format %<cr>", desc = "Ruff format current file" },
      },
    },
  },
}