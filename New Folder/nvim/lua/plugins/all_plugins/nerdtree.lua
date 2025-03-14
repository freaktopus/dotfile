return {
    "preservim/nerdtree",
    dependencies = {
        "ryanoasis/vim-devicons",
    },
    config = function()
        local keymap = vim.keymap

        -- Keybinding to toggle NERDTree
        keymap.set("n", "<M-1>", ":NERDTreeToggle<CR>", { noremap = true })

        -- Show hidden files (including .gitignore, .env, etc.)
        vim.g.NERDTreeShowHidden = 1

        -- Ensure nothing is ignored in NERDTree (show all files)
        vim.g.NERDTreeIgnore = {}  -- Empty list means no files are ignored

        -- Optionally, set up the NERDTree to automatically open in the current directory
        vim.g.NERDTreeQuitOnOpen = 1  -- Close NERDTree after opening a file
    end,
}
