-- Render images inside nvim (kitty graphics protocol).
-- Needs the ImageMagick CLI (`magick`); no luarocks needed with processor = "magick_cli".
return {
	"3rd/image.nvim",
	event = "VeryLazy",
	build = false, -- skip the luarocks magick rock
	opts = {
		backend = "kitty",
		processor = "magick_cli",
		integrations = {
			markdown = {
				enabled = true,
				clear_in_insert_mode = false,
				download_remote_images = true,
				only_render_image_at_cursor = false,
				filetypes = { "markdown", "vimwiki", "Avante" },
			},
			html = { enabled = false },
			css = { enabled = false },
		},
		max_width = 100,
		max_height = 12,
		max_height_window_percentage = math.huge,
		max_width_window_percentage = math.huge,
		window_overlap_clear_enabled = true,
		window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
		editor_only_render_when_focused = false,
		-- open .png/.jpg/... files as an image preview
		hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
	},
}
