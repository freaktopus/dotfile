# Neovim Plugins & Keybindings Guide

This document describes the plugins added to this Neovim configuration, what they do, and how to use them.

## Table of Contents

- [AI / Copilot](#ai--copilot)
- [File Management](#file-management)
- [Navigation](#navigation)
- [Image & PDF Viewers](#image--pdf-viewers)
- [Terminal](#terminal)
- [Telescope](#telescope)
- [Text Editing Helpers](#text-editing-helpers)
- [Full Keybinding Reference](#full-keybinding-reference)
- [Requirements](#requirements)
- [Troubleshooting](#troubleshooting)

---

## AI / Copilot

### Plugins

| Plugin | File | Purpose |
|--------|------|---------|
| `greggh/claude-code.nvim` | `lua/plugins/all_plugins/claude_code.lua` | Opens Claude Code CLI inside a floating Neovim terminal. |
| `zbirenbaum/copilot.lua` | `lua/plugins/all_plugins/copilot.lua` | Core GitHub Copilot integration. |
| `zbirenbaum/copilot-cmp` | `lua/plugins/all_plugins/copilot_cmp.lua` | Adds Copilot suggestions to `nvim-cmp` completion menu. |

### How to use

#### Claude Code

Requires the `claude` command to be installed and in your `$PATH`.

- `<leader>ac` — Toggle Claude Code in a floating window.
- `<leader>aC` — Open Claude Code with `--continue` (resume recent conversation).
- `<leader>aV` — Open Claude Code with `--verbose`.
- Inside the Claude Code terminal, use `<C-h/j/k/l>` to move between windows.
- Files modified by Claude Code are automatically reloaded in Neovim.

#### GitHub Copilot

Copilot suggestions now appear as items in the `nvim-cmp` completion menu instead of inline ghost text. To avoid duplicate suggestions, inline ghost text is disabled in `copilot.lua`.

- In insert mode, start typing and Copilot suggestions appear in the dropdown.
- Use `<Tab>` / `<S-Tab>` to move through the menu.
- Press `<CR>` to accept the selected item.

If you want inline ghost text instead, set `suggestion.enabled = true` in `copilot.lua` and remove the `{ name = "copilot" }` source from `auto_completion.lua`.

---

## File Management

### Plugin: `oil.nvim`

| Plugin | File | Purpose |
|--------|------|---------|
| `stevearc/oil.nvim` | `lua/plugins/all_plugins/oil.lua` | Edit your filesystem like a normal buffer. |

#### How to use

- Press `-` in normal mode to open the parent directory of the current file.
- Press `<leader>e-` to open oil in a floating window.
- Inside oil:
  - `<CR>` — open file or directory
  - `-` — go to parent directory
  - `_` — open current working directory
  - `v` — open in vertical split (`<C-v>`)
  - `s` — open in horizontal split (`<C-h>`)
  - `t` — open in tab (`<C-t>`)
  - `p` — preview
  - `q` — close oil
  - `g.` — toggle hidden files

---

## Navigation

### Plugin: `flash.nvim`

| Plugin | File | Purpose |
|--------|------|---------|
| `folke/flash.nvim` | `lua/plugins/all_plugins/flash.lua` | Jump to any visible character or treesitter node. |

#### How to use

- `s` — Jump to a character/location in the current window.
- `S` — Jump to a treesitter node (function, class, etc.).
- `r` (operator-pending mode) — Remote flash (target another location for an operator).
- `R` (operator/visual mode) — Flash treesitter search.
- `<C-s>` in command mode — Toggle flash search highlighting.

---

## Image & PDF Viewers

### Image preview inside Neovim

| Plugin | File | Purpose |
|--------|------|---------|
| `3rd/image.nvim` | `lua/plugins/all_plugins/image.lua` | Preview images inside Neovim buffers. |

#### Requirements

Only works in terminals that support inline images:

- Kitty (recommended)
- WezTerm
- iTerm2 (with `backend = "iterm"`)
- Some terminals with Ueberzug (`backend = "ueberzug"`)

Edit `lua/plugins/all_plugins/image.lua` and set `backend` to match your terminal.

#### How to use

- Open an image file (`.png`, `.jpg`, `.jpeg`, `.gif`, `.webp`, `.bmp`) and the image will render inside the buffer.
- Works in Markdown files too: images linked with `![alt](path)` will render.

### Open files with the system viewer

PDFs and other images are opened with your system's default application (evince, okular, zathura, feh, etc.).

#### How to use

- `<leader>o` — Open the file under the cursor with the default system application.
- `<leader>O` — Open the directory of the current file with the system file manager.
- When you `:e some-file.pdf`, Neovim will automatically open it externally and close the empty buffer.

This uses Neovim's built-in `vim.ui.open`, which calls `xdg-open` on Linux, `open` on macOS, or `start` on Windows.

---

## Terminal

### Plugin: `toggleterm.nvim`

| Plugin | File | Purpose |
|--------|------|---------|
| `akinsho/toggleterm.nvim` | `lua/plugins/all_plugins/toggleterm.lua` | Floating terminal inside Neovim. |

#### How to use

- `<leader>tt` — Toggle a floating terminal.
- `<localleader>tf` — Also toggles the floating terminal.
- Works from both normal mode and terminal mode.

---

## Telescope

| Plugin | File | Purpose |
|--------|------|---------|
| `nvim-telescope/telescope.nvim` | `lua/plugins/all_plugins/telescope.lua` | Fuzzy finder. |
| `telescope-fzf-native.nvim` | included | Faster fzf-native sorter. |
| `telescope-ui-select.nvim` | included | Use Telescope for `vim.ui.select` prompts. |

#### How to use

- `<leader>f` — Find files in current directory.
- `<leader>F` — Find files tracked by git.
- `<leader>g` — Live grep (search text across files).
- `<leader>ps` — Grep for a string you type.
- `<leader>*` — Grep the word under the cursor.
- `<leader>b` — List open buffers.
- `<leader>h` — Search help tags.

---

## Text Editing Helpers

### `mini.nvim` modules

| Plugin | File | Purpose |
|--------|------|---------|
| `mini.surround` | `lua/plugins/all_plugins/mini.lua` | Add/change/delete surrounding characters. |
| `mini.move` | `lua/plugins/all_plugins/mini.lua` | Move lines or selections up/down/left/right. |
| `mini.ai` | `lua/plugins/all_plugins/mini.lua` | Better text objects (inside/around function, etc.). |

#### How to use

##### mini.surround

Default keybindings (all in normal/visual mode):

- `sa` + motion + char — Add surrounding. Example: `saiw"` surrounds the inner word with quotes.
- `sd` + char — Delete surrounding. Example: `sd"` removes surrounding quotes.
- `sr` + old + new — Replace surrounding. Example: `sr"'` replaces `"` with `'`.
- `sh` — Highlight surrounding.
- `sf` — Find surrounding (move cursor to the right surrounding).
- `sF` — Find surrounding backward.

##### mini.move

- In normal mode: `<Alt-h/j/k/l>` to move the current line or selection.
- In visual mode: `<Alt-h/j/k/l>` to move the selected block.

##### mini.ai

Improves text objects. Examples:

- `vif` — select inside function.
- `vaf` — select around function.
- `vic` — select inside class.
- `dii` — delete inside indent block.

---

## Full Keybinding Reference

### Leader keys

Your `<leader>` is **Space**.
Your `<localleader>` is also **Space** by default.

| Key | Mode | Action |
|-----|------|--------|
| `;` | Normal | Enter command mode (`:`) |
| `jk` | Insert | Exit insert mode |
| `<C-s>` | Normal/Insert/Visual | Save file |
| `<leader>f` | Normal | Find files (Telescope) |
| `<leader>F` | Normal | Find git files (Telescope) |
| `<leader>g` | Normal | Live grep (Telescope) |
| `<leader>ps` | Normal | Grep string (Telescope) |
| `<leader>*` | Normal | Grep word under cursor (Telescope) |
| `<leader>b` | Normal | List buffers (Telescope) |
| `<leader>h` | Normal | Help tags (Telescope) |
| `<leader>ac` | Normal/Toggle | Toggle Claude Code |
| `<leader>aC` | Normal | Claude Code --continue |
| `<leader>aV` | Normal | Claude Code --verbose |
| `<leader>e-` | Normal | Oil floating file manager |
| `-` | Normal | Open parent directory (Oil) |
| `<leader>o` | Normal | Open file under cursor externally |
| `<leader>O` | Normal | Open current directory externally |
| `<leader>tt` | Normal/Terminal | Toggle floating terminal |
| `<localleader>tf` | Normal/Terminal | Toggle floating terminal |
| `s` | Normal/Visual/Operator | Flash jump |
| `S` | Normal/Visual/Operator | Flash treesitter |

---

## Requirements

Install these command-line tools for the related features:

| Tool | Needed for | Install command (Arch / generic) |
|------|------------|----------------------------------|
| `claude` | Claude Code plugin | Install Anthropic's Claude Code CLI |
| `fzf` / `make` | telescope-fzf-native | `sudo pacman -S fzf make` |
| `gcc` / `make` | telescope-fzf-native build | usually installed |
| `magick` (LuaRocks) or terminal with image support | image.nvim | See `3rd/image.nvim` README |
| `xdg-open` | External PDF/image openers | included on most Linux desktops |

### Required image terminal

`image.nvim` only works in a terminal that supports image protocols. If you use GNOME Terminal, Alacritty, or a simple TTY, image preview will not work. Use Kitty or WezTerm for best results.

---

## Troubleshooting

### `<leader>tt` does not open the terminal

1. Make sure you are pressing `Space` then `t` then `t` quickly enough.
2. Run `:map <leader>tt` to verify the mapping exists.
3. If `<leader>t` group conflicts, increase `timeoutlen` in `lua/options.lua`.

### Claude Code command not found

Run `which claude` in your terminal. If it is missing, install Claude Code first:

```bash
npm install -g @anthropic-ai/claude-code
```

Or follow the official Anthropic instructions.

### Copilot suggestions not appearing in the menu

1. Run `:Copilot auth` to sign in.
2. Make sure `suggestion.enabled = false` in `lua/plugins/all_plugins/copilot.lua`.
3. Make sure `{ name = "copilot" }` is in the sources list in `lua/plugins/all_plugins/auto_completion.lua`.
4. Restart Neovim.

### Images do not render inside Neovim

1. Verify your terminal supports Kitty graphics or iTerm inline images.
2. Check `lua/plugins/all_plugins/image.lua` and set `backend` to your terminal type.
3. Install the Lua `magick` rock if required: `luarocks install magick --local`.

### PDF opens as garbage text instead of in external viewer

Make sure the autocommand in `lua/autocmds.lua` is loaded. It opens files matching `*.pdf` with `vim.ui.open`. If you open a PDF with a command that bypasses the autocmd, use `<leader>o` instead.

### Some files are owned by `root`

If you ever ran `sudo nvim`, you may have created files owned by `root`. Fix with:

```bash
sudo chown -R sannux:sannux /home/sannux/.config/nvim
```

---

## How to update this config

After editing any plugin file:

1. Save the file.
2. Restart Neovim, or run:
   ```vim
   :Lazy sync
   ```
3. Run `:checkhealth` to diagnose missing dependencies.

---

*Generated for the NvChad-based Neovim config at `~/.config/nvim`.*
