return {
  {
    "stevearc/conform.nvim",
    -- event = 'bufwritepre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },
  -- these are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

{
      "xiyaowong/transparent.nvim",
      config = function()
         require("transparent").setup({
            enable = true, -- enable transparent mode
            extra_groups = { -- table of groups that should be cleared
               -- example groups (see more in the plugin documentation)
               "Normal",
               "NormalNC",
               "TelescopeNormal",
               "TelescopeBorder",
            },
            exclude = {}, -- table: groups you don't want to clear
         })
      end,
   },


{
  'akinsho/toggleterm.nvim',
  config = function()
    require("toggleterm").setup({
      size = 20,  -- Set the terminal size
      direction = "float",  -- Floating terminal
      hide_numbers = true,  -- Hide line numbers in terminal
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,  -- Darken background
      start_in_insert = true,  -- Start terminal in insert mode
      insert_mappings = true,  -- Enable insert mode mappings
      terminal_mappings = true,  -- Enable terminal mappings
    })
 -- Custom keybinding to open the terminal
    vim.api.nvim_set_keymap('n', '<Space>h', '<Cmd>ToggleTerm<CR>', { noremap = true, silent = true })
  end
},


 -- Add nvim-tree plugin here
  {
    "nvim-tree/nvim-tree.lua",
    requires = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
    },
    config = function()
      require("nvim-tree").setup {
        git = {
          enable = true,
          ignore = false,  -- Set to false to show gitignored files like .env
        },
        filters = {
          dotfiles = false,  -- Set to false to show dotfiles like .env
        },
        -- You can add more configuration options here if needed
      }
    end,
  },

  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    opts = function()
      return require "nvchad.configs.telescope"
    end,
    config = function(_, opts)
      local telescope = require "telescope"
      telescope.setup(opts)

      -- load extensions
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },

  -- Highlight, edit, and navigate code
{
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      return require "nvchad.configs.treesitter"
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
     -- live server
	{
		"aurum77/live-server.nvim",
		run = function()
			require("live_server.util").install()
		end,
		cmd = { "LiveServer", "LiveServerStart", "LiveServerStop" },
	  },
  {
  	"williamboman/mason.nvim",
  	opts = {
  		ensure_installed = {
  			"lua-language-server", "stylua",
  			"html-lsp", "css-lsp" , "prettier", "rust-analyzer", "pyright"
  		},
  	},
  },
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function ()
      vim.g.rustfmt_autosave = 1
    end
  },
}



