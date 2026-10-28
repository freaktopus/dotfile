return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✅",
						package_pending = "⭕",
						package_uninstalled = "✗",
					},
					border = "rounded",
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"pyright",
					"ts_ls",
					"clangd",
					"gopls",
					"html",
					"cssls",
					"tailwindcss",
					"bashls",
					"jsonls",
					"yamlls",
					"dockerls",
					"marksman",
					"svelte",
					"graphql",
					"ocamllsp",
					"texlab",
					"eslint",
				},
				automatic_installation = false,
			})
		end,
	},
}
