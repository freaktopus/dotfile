pcall(function()
  dofile(vim.g.base46_cache .. "syntax")
  dofile(vim.g.base46_cache .. "treesitter")
end)

local options = {
  ensure_installed = { "vim", "lua", "vimdoc", "html", "css","python",},

  highlight = {
    enable = true,
    use_languagetree = true,
  },
  indent = { enable = true },
}

return options


