local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    python = { "isort", "black" },
    -- You can customize some of the format options for the filetype (:help conform.format)
    rust = { "rustfmt", lsp_format = "fallback" },
    -- Conform will run the first available formatter
    javascript = { { "eslint_d" }, "prettierd", "prettier", stop_after_first = true },
    typescript = { { "eslint_d" } },
    typescriptreact = { { "eslint_d" } },
    ocaml = { "ocamlformat" },
    c = { { "clang-format" } },
    xml = { { "xmlformat" } },
    html = { "htmlbeautifier" },
    ["*"] = { "trim_whitespace", "squeeze_blanks", "trim_newlines" },
  },
  format_on_save = function(bufnr)
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if bufname:match("/node_modules/") or bufname:match("/vendor/") then
      return
    end
    return { async = true, timeout_ms = 500, lsp_fallback = true }
  end,
  log_level = vim.log.levels.ERROR,
  notify_on_error = true,
}

return options

