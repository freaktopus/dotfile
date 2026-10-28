require "nvchad.options"

-- add yours here!

local o = vim.o

o.cursorlineopt = "both" -- to enable cursorline!
o.timeoutlen = 300         -- time to wait for a mapped sequence to complete (raised for which-key)
o.ttimeoutlen = 10         -- time to wait for a key code sequence to complete

-- this is to copy from nvim to browser but it is working in default
-- vim.opt.clipboard = "unnamedplus"

-- Point OpenCode at the TUI config used when it runs inside Neovim
-- (the env var is inherited by terminal jobs).
-- That config keeps mouse capture on, so the wheel scrolls the chat
-- and Shift+wheel falls back to Neovim's own scrollback.
vim.env.OPENCODE_TUI_CONFIG = vim.fn.expand "~/.config/opencode/tui-nvim.json"
