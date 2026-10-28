local nvlsp = require("nvchad.configs.lspconfig")

vim.lsp.config("*", {
	capabilities = nvlsp.capabilities,
	on_attach = nvlsp.on_attach,
	on_init = nvlsp.on_init,
})
local servers = {
	"lua_ls", "pyright", "ts_ls", "rust_analyzer",
	"clangd", "gopls", "html", "cssls", "tailwindcss",
	"bashls", "jsonls", "yamlls", "dockerls", "marksman"
}

for _, server in ipairs(servers) do
	vim.lsp.enable(server)
end
