return {
  -- Collection of small, focused plugins from the mini.nvim library.
  { "echasnovski/mini.surround", version = false, config = function() require("mini.surround").setup() end },
  { "echasnovski/mini.move",     version = false, config = function() require("mini.move").setup() end },
  { "echasnovski/mini.ai",       version = false, config = function() require("mini.ai").setup() end },
}
