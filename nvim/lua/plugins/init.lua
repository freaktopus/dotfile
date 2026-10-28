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


  { import = "plugins.all_plugins" },

}
