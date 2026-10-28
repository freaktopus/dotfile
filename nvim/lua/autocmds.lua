-- User autocommands.
-- This file is loaded from init.lua after nvchad.autocmds.

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Automatically open PDF and image files in the system default viewer.
local media_group = augroup("OpenMediaExternally", { clear = true })

autocmd("BufReadPost", {
  group = media_group,
  pattern = { "*.pdf", "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.bmp" },
  callback = function(args)
    local file = vim.fn.fnameescape(args.file)

    -- Close the buffer so binary content is not displayed.
    vim.api.nvim_buf_delete(args.buf, { force = true })

    -- Open with the system default application.
    vim.ui.open(file)
  end,
})

-- Auto-resize windows when the terminal is resized.
local resize_group = augroup("ResizeWindows", { clear = true })

autocmd("VimResized", {
  group = resize_group,
  pattern = "*",
  command = "wincmd =",
})

-- Highlight yanked text briefly.
local yank_group = augroup("HighlightYank", { clear = true })

autocmd("TextYankPost", {
  group = yank_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 200,
    })
  end,
})

-- Mouse behavior in terminal buffers.
--
-- OpenCode runs inside Neovim with mouse capture disabled (see
-- OPENCODE_TUI_CONFIG in options.lua), so mouse events are handled by
-- Neovim itself instead of being forwarded as escape sequences into
-- OpenCode's input field (which caused the garbage text). This means
-- drag-selection works natively in terminal buffers again.
--
-- These mappings make the scroll wheel send PageUp/PageDown to the
-- program running in the terminal, so the wheel scrolls OpenCode's
-- chat history (OpenCode binds pageup/pagedown to messages_page_up/down).
local terminal_group = augroup("TerminalMouse", { clear = true })

autocmd("TermOpen", {
  group = terminal_group,
  pattern = "*",
  callback = function(args)
    local function send_keys(keys)
      local chan = vim.bo[args.buf].channel
      if chan > 0 then
        vim.api.nvim_chan_send(chan, keys)
      end
    end

    local opts = { buffer = args.buf, silent = true }

    -- Map in both terminal-job mode and normal mode so the wheel always
    -- scrolls the program's content instead of Neovim's scrollback.
    for _, mode in ipairs { "t", "n" } do
      vim.keymap.set(mode, "<ScrollWheelUp>", function()
        send_keys "\x1b[5~" -- PageUp
      end, opts)

      vim.keymap.set(mode, "<ScrollWheelDown>", function()
        send_keys "\x1b[6~" -- PageDown
      end, opts)
    end
  end,
})
