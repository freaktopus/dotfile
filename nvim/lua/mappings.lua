-- Usages: For the keymap

require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

-- Map ; to enter command mode. This replaces the default ; behavior
-- (repeat last f/F/t/T motion), so use , for that or press : explicitly.
map("n", ";", ":", { desc = "CMD enter command mode" })

map("i", "jk", "<ESC>")

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Open the file under cursor with the system default application.
-- Useful for opening PDFs and images in external viewers.
map("n", "<leader>o", function()
  local file = vim.fn.expand("<cfile>")
  if file == "" then
    file = vim.api.nvim_buf_get_name(0)
  end
  if file == "" then
    vim.notify("No file to open", vim.log.levels.WARN)
    return
  end
  vim.ui.open(file)
end, { desc = "Open file under cursor with system viewer" })

-- Open current file's directory in the system file manager.
map("n", "<leader>O", function()
  local dir = vim.fn.expand("%:p:h")
  vim.ui.open(dir)
end, { desc = "Open file directory in system file manager" })

