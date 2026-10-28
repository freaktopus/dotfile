return {
	"dfendr/clipboard-image.nvim",
	config = function()
		require("clipboard-image").setup({
			default = {
				img_dir = "assets",
				img_name = function()
					return os.date("%Y-%m-%d-%H-%M-%S")
				end, -- Example result: "2021-04-13-10-04-18"
				affix = "<\n  %s\n>", -- Multi lines affix
			},

			markdown = {
				img_dir = { "static", "img" }, -- Use table for nested dir
				img_dir_txt = "/img",
				-- WARNING: removed unsafe os.execute handler that ran a shell script
				-- from the current working directory. Do not execute arbitrary scripts
				-- from project directories.
			},
		})
	end,
}
