return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Add OpenAPI Language Server for YAML files
      local lspconfig = require("lspconfig")
      
      -- Custom OpenAPI Language Server setup
      lspconfig.openapi_ls = {
        default_config = {
          cmd = { "openapi-language-server" },
          filetypes = { "yaml" },
          root_dir = lspconfig.util.root_pattern(".git", "openapi.yaml", "openapi.yml", "swagger.yaml", "swagger.yml"),
          single_file_support = true,
        },
      }
      
      -- Also configure yamlls with OpenAPI schema validation
      opts.servers.yamlls = {
        settings = {
          yaml = {
            schemas = {
              ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.yaml"] = "openapi*.{yml,yaml}",
              ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.0/schema.yaml"] = "swagger*.{yml,yaml}",
            },
            validate = true,
            hover = true,
            completion = true,
          },
        },
      }
      
      -- Set up OpenAPI Language Server
      opts.servers.openapi_ls = {}
      
      return opts
    end,
  },
}