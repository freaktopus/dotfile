return {
  "mrcjkb/rustaceanvim",
  version = "^5", -- Recommended
  ft = { "rust" },
  config = function()
    -- Auto-format Rust files on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.rs",
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })
  end,
  opts = {
    server = {
      autostart = true,
      on_attach = function(client, bufnr)
        -- Set up keymaps here if needed
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
      end,
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            command = "clippy",
            extraArgs = { "--", "-W", "warnings" },
          },
          assist = {
            importGranularity = "module",
            importPrefix = "by_self",
          },
          cargo = {
            loadOutDirsFromCheck = true,
            allFeatures = true,
          },
          procMacro = {
            enable = true,
          },
          inlayHints = {
            bindingModeHints = { enable = true },
            chainingHints = { enable = true },
            closingBraceHints = { enable = true, minLines = 25 },
            closureReturnTypeHints = { enable = "always" },
            lifetimeElisionHints = { enable = "always" },
            parameterHints = { enable = true },
            typeHints = { enable = true },
          },
        },
      },
    },
    -- Additional rustaceanvim-specific settings
    dap = {
      autoload_configurations = true,
    },
    tools = {
      hover_actions = {
        auto_focus = true,
      },
    },
  },
}
