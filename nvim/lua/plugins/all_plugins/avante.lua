return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	version = false, -- always track main; release tags lag behind
	build = "make",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"zbirenbaum/copilot.lua", -- avante reuses copilot.lua's GitHub login
		"HakonHarnes/img-clip.nvim", -- paste screenshots into the avante prompt
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
	opts = {
		provider = "copilot",
		providers = {
			copilot = {
				model = "claude-sonnet-4",
				timeout = 30000,
				extra_request_body = {
					temperature = 0,
					max_tokens = 8192,
				},
			},
		},
		behaviour = {
			auto_suggestions = false, -- copilot.lua already does inline suggestions
		},
		mappings = {
			submit = {
				insert = "<C-CR>",
			},
		},
		windows = {
			wrap = true,
			width = 40,
			sidebar_header = {
				align = "right",
				rounded = true,
			},
		},
	},
}
