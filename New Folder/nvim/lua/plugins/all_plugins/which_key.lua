local border = {
	line = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
	rectangle = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
}

return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},
	config = function()
		local toggleterm_terminal = require("toggleterm.terminal").Terminal
		local toggleterm_toggle = function()
			local float = toggleterm_terminal:new({ direction = "float" })
			return float:toggle()
		end

		local which_k = require("which-key")

		which_k.setup({
			win = {
				border = border,
			},
			layout = { align = "center" },
		})

		-- Update to new format
		which_k.add({
			{ "<leader>f", group = "Telescope find file" },
			{ "<leader>ps", group = "Telescope grep text and find files" },
			{ "<leader>d", group = "debug/database" },
			{ "<leader>dh", desc = "dap hydra" },
			{ "<leader>h", group = "git-action" },
			{ "<leader>n", group = "new" },
			{ "<leader>j", group = "jump" },
			{ "<leader>p", group = "packages" },
			{ "<leader>q", group = "quit" },
			{ "<leader>l", group = "list" },
			{ "<leader>i", group = "iswap" },
			{ "<leader>e", group = "edit" },
			{ "<leader>r", group = "lsp-refactor" },
			{ "<leader>o", group = "only" },
			{ "<leader>t", group = "tab" },
			{ "<leader>s", group = "source/swap" },
			{ "<leader>y", group = "yank" },
			{ "<leader>O", group = "options" },
			{ "<localleader>tf", toggleterm_toggle, desc = "Toggle Floating Terminal" },
		})
	end,
}

