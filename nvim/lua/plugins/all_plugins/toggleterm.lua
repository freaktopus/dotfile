return {
  "akinsho/toggleterm.nvim",
  version = "*",
  lazy = false, -- load immediately so the keymap is always available
  config = function()
    require("toggleterm").setup({
      direction = "float",
      terminal_mappings = false,
      start_in_insert = true,
      auto_scroll = true,
      close_on_exit = true,
      persist_size = false,
      persist_mode = false,
      shell = vim.o.shell,
      on_open = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.cursorline = false
        vim.opt_local.signcolumn = "no"
      end,
      float_opts = {
        border = "curved",
        winblend = 0,
        width = math.floor(vim.o.columns * 0.8),
        height = math.floor(vim.o.lines * 0.8),
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    })

    local Terminal = require("toggleterm.terminal").Terminal
    local float_term = Terminal:new({
      direction = "float",
      on_stdout = function() end,
      on_stderr = function() end,
      on_exit = function() end,
    })

    function _TOGGLE_FLOAT_TERM()
      if float_term:is_open() then
        float_term:close()
      else
        float_term:open()
      end
    end

    -- Register the keymap in both normal and terminal modes.
    vim.keymap.set({ "n", "t" }, "<leader>tt", function()
      _TOGGLE_FLOAT_TERM()
    end, { desc = "Toggle Floating Terminal", noremap = true, silent = true })
  end,
}
