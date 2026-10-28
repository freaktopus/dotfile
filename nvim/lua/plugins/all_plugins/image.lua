return {
  "3rd/image.nvim",
  -- Only load when we actually open an image file.
  ft = { "png", "jpg", "jpeg", "gif", "webp", "bmp" },
  config = function()
    require("image").setup({
      backend = "kitty", -- Change to "ueberzug" or "iterm" if needed.
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" },
        },
        html = {
          enabled = false,
        },
        css = {
          enabled = true,
        },
      },
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = false,
      editor_only_render_when_focused = false,
      tmux_show_only_in_active_window = false,
      kitty_method = "normal",
      kitty_tmux_write_delay = 10,
    })
  end,
}
