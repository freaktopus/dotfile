return {

  {
    "stevearc/conform.nvim",
    -- event = 'bufwritepre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfigs"
    end,
  },

  
{
  "echasnovski/mini.icons",
  version = false,
  config = function()
    require("mini.icons").setup()
  end
},


 { import = "plugins.all_plugins"},


--  -- Add nvim-tree plugin here
--   {
--     "nvim-tree/nvim-tree.lua",
--     requires = {
--       "nvim-tree/nvim-web-devicons", -- optional, for file icons
--     },
--     config = function()
--       require("nvim-tree").setup {
--         git = {
--           enable = true,
--           ignore = false,  -- Set to false to show gitignored files like .env
--         },
--         filters = {
--           dotfiles = false,  -- Set to false to show dotfiles like .env
--         },
--         -- You can add more configuration options here if needed
--       }
--     end,
--   },
--
--   -- telescope
--   {
--     "nvim-telescope/telescope.nvim",
--     dependencies = { "nvim-treesitter/nvim-treesitter" },
--     cmd = "Telescope",
--     opts = function()
--       return require "nvchad.configs.telescope"
--     end,
--     config = function(_, opts)
--       local telescope = require "telescope"
--       telescope.setup(opts)
--
--       -- load extensions
--       for _, ext in ipairs(opts.extensions_list) do
--         telescope.load_extension(ext)
--       end
--     end,
--   },
--
--   -- Highlight, edit, and navigate code
-- {
--     "nvim-treesitter/nvim-treesitter",
--     event = { "BufReadPost", "BufNewFile" },
--     cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
--     build = ":TSUpdate",
--     opts = function()
--       return require "nvchad.configs.treesitter"
--     end,
--     config = function(_, opts)
--       require("nvim-treesitter.configs").setup(opts)
--     end,
--   },
--      -- live server
-- 	{
-- 		"aurum77/live-server.nvim",
-- 		run = function()
-- 			require("live_server.util").install()
-- 		end,
-- 		cmd = { "LiveServer", "LiveServerStart", "LiveServerStop" },
-- 	  },
--   {
--   	"williamboman/mason.nvim",
--   	opts = {
--   		ensure_installed = {
--   			"lua-language-server", "stylua",
--   			"html-lsp", "css-lsp" , "prettier", "rust-analyzer", "pyright"
--   		},
--   	},
--   },
--   {
--     "rust-lang/rust.vim",
--     ft = "rust",
--     init = function ()
--       vim.g.rustfmt_autosave = 1
--     end
--   },
}





