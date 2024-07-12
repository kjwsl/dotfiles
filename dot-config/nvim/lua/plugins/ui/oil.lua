return {
    "stevearc/oil.nvim",
    opts = {
        delete_to_trash = true,
        use_default_keymaps = false,
        keymaps = {
            ["g?"] = "actions.show_help",
            ["<CR>"] = "actions.select",
            ["<C-5>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
            ["<C-'>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
            ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
            ["<C-p>"] = "actions.preview",
            ["<C-c>"] = "actions.close",
            ["<C-l>"] = "actions.refresh",
            ["-"] = "actions.parent",
            ["_"] = "actions.open_cwd",
            ["`"] = "actions.cd",
            ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
            ["gs"] = "actions.change_sort",
            ["gx"] = "actions.open_external",
            ["g."] = "actions.toggle_hidden",
            ["g\\"] = "actions.toggle_trash",
        },
        watch_for_changes = true,
        view_options = {
            show_hidden = true
        }
    },
    dependencies = {
        'nvim-tree/nvim-web-devicons'
    },
}
