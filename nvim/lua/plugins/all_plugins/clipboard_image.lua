-- Paste screenshots from the clipboard into any file (markdown, html, latex, ...).
-- <leader>ip or  :PasteImage   — works with Print (sway screenshot) on Wayland via wl-paste.
return {
	"HakonHarnes/img-clip.nvim",
	event = "VeryLazy",
	opts = {
		default = {
			dir_path = "assets",
			file_name = "%Y-%m-%d-%H-%M-%S",
			use_absolute_path = false,
			relative_to_current_file = true,
			prompt_for_file_name = false,
			drag_and_drop = { insert_mode = true },
		},
		filetypes = {
			markdown = {
				dir_path = "img",
				template = "![$CURSOR]($FILE_PATH)",
			},
		},
	},
	keys = {
		{ "<leader>ip", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
	},
}
