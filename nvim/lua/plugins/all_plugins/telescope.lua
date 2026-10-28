return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-telescope/telescope-ui-select.nvim",
	},
	config = function()
		local keymap = vim.keymap
		local fn = vim.fn
		local builtin = require("telescope.builtin")

		keymap.set("n", "<leader>f", "<cmd>Telescope find_files<CR>", { noremap = true, desc = "Find files" })
		keymap.set("n", "<leader>F", "<cmd>Telescope git_files<CR>", { noremap = true, desc = "Find git files" })
		keymap.set("n", "<leader>ps", function()
			builtin.grep_string({ search = fn.input("Grep > ") })
		end, { noremap = true, desc = "Grep string" })
		keymap.set("n", "<leader>g", "<cmd>Telescope live_grep<CR>", { noremap = true, desc = "Live grep" })
		keymap.set("n", "<leader>b", "<cmd>Telescope buffers<CR>", { noremap = true, desc = "Buffers" })
		keymap.set("n", "<leader>h", "<cmd>Telescope help_tags<CR>", { noremap = true, desc = "Help tags" })
		keymap.set("n", "<leader>*", "<cmd>Telescope grep_string<CR>", { noremap = true, desc = "Grep word under cursor" })

		require("telescope").setup({
			defaults = {
				layout_strategy = "vertical",
				layout_config = {
					width = 0.9,
					height = 0.9,
					preview_cutoff = 1,
					prompt_position = "bottom",
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
				["ui-select"] = {
					require("telescope.themes").get_dropdown({}),
				},
			},
		})

		require("telescope").load_extension("fzf")
		require("telescope").load_extension("ui-select")
	end,
}

