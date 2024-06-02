return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    dependencies = {
        'nvim-lua/plenary.nvim',
        {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'},
        'BurntSushi/ripgrep',
        'sharkdp/fd',
        'nvim-treesitter/nvim-treesitter',
    },
    config = function()
        local telescope = require('telescope')
        local actions =  require('telescope.actions')
        telescope.setup ({
            defaults = {
                path_display = { "truncate "}, -- Example configuration
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    },
                },
            },
        })
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {desc = "Find Files"})
        vim.keymap.set('n', '<leader>fc', builtin.commands, {desc = "Find Commands"})
        vim.keymap.set('n', '<leader>fl', builtin.live_grep, {desc = "Find Live Grep"})
        vim.keymap.set('n', '<leader>fb', builtin.buffers, {desc = "Find Buffers"})
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, {desc = "Find Help Tags"})
        vim.keymap.set('n', '<leader>fq', builtin.quickfix, {desc = "Find Quickfix"})
        vim.keymap.set('n', '<leader>fj', builtin.jumplist, {desc = "Find Jumplist"})
        vim.keymap.set('n', '<leader>fo', builtin.oldfiles, {desc = "Find Old Files"})
        vim.keymap.set('n', '<leader>fr', builtin.registers, {desc = "Find Registers"})
        vim.keymap.set('n', '<leader>fk', builtin.keymaps, {desc = "Find Keymaps"})
        vim.keymap.set('n', '<leader>fv', builtin.vim_options, {desc = "Find Vim Options"})
    end,
}
