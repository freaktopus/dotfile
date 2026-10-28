return {
  "stevearc/oil.nvim",
  -- Load oil on a keymap so it does not slow startup.
  keys = {
    { "-", "<CMD>Oil<CR>", desc = "Open parent directory in oil" },
    { "<leader>e-", "<CMD>Oil --float<CR>", desc = "Open oil in floating window" },
  },
  config = function()
    require("oil").setup({
      default_file_explorer = true,
      columns = {
        "icon",
        "permissions",
      },
      -- Keymaps inside oil buffer.
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["p"] = "actions.preview",
        ["q"] = "actions.close",
        ["r"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
      },
      use_default_keymaps = false,
      view_options = {
        show_hidden = true,
        natural_order = true,
      },
      float = {
        padding = 2,
        max_width = 90,
        max_height = 0,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
      },
    })
  end,
}
