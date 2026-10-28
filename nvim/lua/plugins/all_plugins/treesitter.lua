return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      ensure_installed = {
        "starlark", "awk", "bash", "c", "cmake", "css", "diff", "dockerfile",
        "dot", "gitattributes", "gitignore", "go", "java", "javascript", "jq",
        "jsdoc", "json", "lua", "make", "markdown", "php", "phpdoc", "python",
        "query", "regex", "ruby", "rust", "perl", "scss", "solidity", "sql",
        "svelte", "toml", "tsx", "twig", "typescript", "vim", "vue", "yaml",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
    end,
  },
}
