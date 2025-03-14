-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

-- Define servers to configure with default settings
-- Remove any server that isn't available in your lspconfig version
local servers = {
  "html", "cssls", "clangd", "eslint", "lua_ls", "ocamllsp", 
  "texlab", "gopls", "bashls", "jsonls", "yamlls",
  "dockerls", "svelte", "vuels", "graphql", "marksman"
}

-- lsps with default config
for _, lsp in ipairs(servers) do
  -- Check if the server exists in lspconfig before setup
  if lspconfig[lsp] then
    lspconfig[lsp].setup {
      on_attach = nvlsp.on_attach,
      on_init = nvlsp.on_init,
      capabilities = nvlsp.capabilities,
    }
  else
    print("LSP server not found: " .. lsp)
  end
end

-- TypeScript - use ts_ls instead of tsserver as per deprecation warning
if lspconfig.ts_ls then
  lspconfig.ts_ls.setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true
        }
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true
        }
      }
    }
  }
end


-- Lua language server with custom settings
lspconfig.lua_ls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" }
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false
      },
      telemetry = {
        enable = false
      }
    }
  }
}

-- C/C++ (clangd) with custom settings
if lspconfig.clangd then
  lspconfig.clangd.setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--header-insertion=iwyu",
      "--completion-style=detailed",
      "--function-arg-placeholders"
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" }
  }
end

-- Python with custom settings
if lspconfig.pyright then
  lspconfig.pyright.setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "openFilesOnly",
          useLibraryCodeForTypes = true,
          typeCheckingMode = "basic"
        }
      }
    }
  }
end

-- HTML with custom settings
if lspconfig.html then
  lspconfig.html.setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    filetypes = { "html", "htmldjango" },
    settings = {
      html = {
        format = {
          indentInnerHtml = true,
          wrapLineLength = 120,
          wrapAttributes = "auto"
        },
        suggest = {
          html5 = true
        }
      }
    }
  }
end

-- CSS with custom settings
if lspconfig.cssls then
  lspconfig.cssls.setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    settings = {
      css = {
        validate = true,
        lint = {
          unknownAtRules = "ignore"
        }
      },
      scss = {
        validate = true,
        lint = {
          unknownAtRules = "ignore"
        }
      },
      less = {
        validate = true,
        lint = {
          unknownAtRules = "ignore"
        }
      }
    }
  }
end

-- Dart language server
if lspconfig.dartls then
  lspconfig.dartls.setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    cmd = { "dart", "language-server", "--protocol=lsp" },
    filetypes = { "dart" },
    root_dir = require("lspconfig/util").root_pattern("pubspec.yaml", ".git"),
  }
end

-- JSON with schema support
if lspconfig.jsonls then
  -- Check if schemastore is available
  local has_schemastore, schemastore = pcall(require, 'schemastore')
  local schemas = has_schemastore and schemastore.json.schemas() or {}

  lspconfig.jsonls.setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    settings = {
      json = {
        schemas = schemas,
        validate = { enable = true }
      }
    }
  }
end

-- Format on save for different file types
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.html", "*.css", "*.scss", "*.json", "*.lua", "*.py", "*.rs", "*.c", "*.cpp", "*.h", "*.hpp", "*.go", "*.dart", "*.yaml", "*.yml", "*.md" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
