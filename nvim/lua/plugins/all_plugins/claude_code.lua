return {
  "greggh/claude-code.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  cmd = {
    "ClaudeCode",
    "ClaudeCodeContinue",
    "ClaudeCodeResume",
    "ClaudeCodeVerbose",
  },
  config = function()
    require("claude-code").setup({
      window = {
        position = "float",
        enter_insert = true,
        hide_numbers = true,
        hide_signcolumn = true,
        float = {
          width = "90%",
          height = "85%",
          row = "center",
          col = "center",
          relative = "editor",
          border = "rounded",
        },
      },
      refresh = {
        enable = true,
        updatetime = 100,
        timer_interval = 1000,
        show_notifications = true,
      },
      git = {
        use_git_root = true,
      },
      command = "claude",
      command_variants = {
        continue = "--continue",
        resume = "--resume",
        verbose = "--verbose",
      },
      keymaps = {
        toggle = {
          normal = "<leader>ac",
          terminal = "<leader>ac",
          variants = {
            continue = "<leader>aC",
            verbose = "<leader>aV",
          },
        },
        window_navigation = true,
        scrolling = true,
      },
    })
  end,
}
