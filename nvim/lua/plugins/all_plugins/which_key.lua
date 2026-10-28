local border = {
  line = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
  rectangle = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
}

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  config = function()
    local which_k = require("which-key")

    which_k.setup({

      win = {
        border = border,
      },
      layout = { align = "center" },
    })

    -- Update to new format
    which_k.add({
      { "<leader>f",  group = "Telescope find file" },
      { "<leader>F",  desc = "Find git files" },
      { "<leader>ps", group = "Telescope grep text and find files" },
      { "<leader>g",  desc = "Live grep" },
      { "<leader>b",  desc = "Buffers" },
      { "<leader>h",  desc = "Help tags" },
      { "<leader>*",  desc = "Grep word under cursor" },
      { "<leader>d",  group = "debug/database" },
      { "<leader>dh", desc = "dap hydra" },
      { "<leader>a",  group = "AI / Claude Code" },
      { "<leader>ac", desc = "Toggle Claude Code" },
      { "<leader>aC", desc = "Claude Code Continue" },
      { "<leader>aV", desc = "Claude Code Verbose" },
      { "<leader>n",  group = "new" },
      { "<leader>j",  group = "jump" },
      { "<leader>p",  group = "packages" },
      { "<leader>q",  group = "quit" },
      { "<leader>l",  group = "list" },
      { "<leader>i",  group = "iswap" },
      { "<leader>e",  group = "edit / file" },
      { "<leader>e-", desc = "Oil floating file manager" },
      { "<leader>r",  group = "lsp-refactor" },
      { "<leader>o",  desc = "Open file under cursor externally" },
      { "<leader>O",  desc = "Open directory externally" },
      { "<leader>s",  group = "source/swap" },
      { "<leader>y",  group = "yank" },
      { "<leader>t",  group = "tab / terminal" },
      { "<leader>tt", desc = "Toggle floating terminal" },
      { "<localleader>tf", desc = "Toggle floating terminal (local leader)" },
    })
  end,
}
