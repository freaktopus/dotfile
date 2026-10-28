-- This file configures and enables LSP servers.
-- NvChad already provides default capabilities, on_attach, and on_init.
-- We use the native Neovim 0.11+ API: vim.lsp.config() + vim.lsp.enable().

local nvlsp = require("nvchad.configs.lspconfig")

-- Default config applied to every LSP server.
-- * means "all servers".
vim.lsp.config("*", {
  capabilities = nvlsp.capabilities,
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
})

-- Server-specific overrides.
-- Each call merges with the default config above.

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config("pyright", {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "basic",
      },
    },
  },
})

vim.lsp.config("ts_ls", {
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
})

vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--offset-encoding=utf-16",
  },
})

vim.lsp.config("html", {
  filetypes = { "html", "htmldjango" },
})

vim.lsp.config("cssls", {
  settings = {
    css = { validate = true, lint = { unknownAtRules = "ignore" } },
    scss = { validate = true, lint = { unknownAtRules = "ignore" } },
    less = { validate = true, lint = { unknownAtRules = "ignore" } },
  },
})

vim.lsp.config("tailwindcss", {
  filetypes = {
    "html", "css", "scss", "javascript", "javascriptreact",
    "typescript", "typescriptreact", "vue", "svelte",
  },
})

vim.lsp.config("jsonls", {
  settings = {
    json = { validate = { enable = true } },
  },
})

-- rust_analyzer is managed by rustaceanvim, so do NOT enable it here.
local servers = {
  "lua_ls",
  "pyright",
  "ts_ls",
  "clangd",
  "gopls",
  "html",
  "cssls",
  "tailwindcss",
  "bashls",
  "jsonls",
  "yamlls",
  "dockerls",
  "marksman",
  "svelte",
  "vuels",
  "graphql",
  "ocamllsp",
  "texlab",
  "dartls",
  "eslint",
}

for _, server in ipairs(servers) do
  vim.lsp.enable(server)
end
