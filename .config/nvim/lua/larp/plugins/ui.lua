return {
    {
        'folke/noice.nvim',
        event = 'VeryLazy',
        opts = {
            -- add any options here
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            'MunifTanjim/nui.nvim',
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            'rcarriga/nvim-notify',
        },
        config = function()
            require('noice').setup({
                lsp = {
                    signature = { enabled = false },
                    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                    override = {
                        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                        ['vim.lsp.util.stylize_markdown'] = true,
                        ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
                    },
                },
                -- you can enable a preset for easier configuration
                presets = {
                    bottom_search = true, -- use a classic bottom cmdline for search
                    command_palette = false, -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false, -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = true, -- add a border to hover docs and signature help
                },
            })
            vim.api.nvim_create_autocmd('RecordingEnter', {
                callback = function()
                    local msg = string.format('Register:  %s', vim.fn.reg_recording())
                    _MACRO_RECORDING_STATUS = true
                    vim.notify(msg, vim.log.levels.INFO, {
                        title = 'Macro Recording',
                        keep = function()
                            return _MACRO_RECORDING_STATUS
                        end,
                    })
                end,
                group = vim.api.nvim_create_augroup('NoiceMacroNotfication', { clear = true }),
            })

            vim.api.nvim_create_autocmd('RecordingLeave', {
                callback = function()
                    _MACRO_RECORDING_STATUS = false
                    vim.notify('Success!', vim.log.levels.INFO, {
                        title = 'Macro Recording End',
                        timeout = 2000,
                    })
                end,
                group = vim.api.nvim_create_augroup('NoiceMacroNotficationDismiss', { clear = true }),
            })
            larp.fn.map('n', '<leader>dn', '<cmd>NoiceDismiss<cr>', { desc = 'Dismiss Notification' })
        end,
    },
    {
        'nvimdev/dashboard-nvim',
        event = 'VimEnter',
        opts = {
            hide = {
                tabline = true,
            },
        },
        config = function()
            require('dashboard').setup({
                -- config
            })
        end,
        dependencies = { { 'nvim-tree/nvim-web-devicons' } },
    },
    {
        'stevearc/dressing.nvim',
        opts = {},
    },
    {
        'j-hui/fidget.nvim',
        opts = {
            -- options
        },
    },
    {
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v3.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
            'MunifTanjim/nui.nvim',
            '3rd/image.nvim', -- Optional image support in preview window: See `# Preview Mode` for more information
        },
    },
    {
        'nacro90/numb.nvim',
        config = true,
    },
    {
        'kevinhwang91/nvim-bqf',
    },
    {
        'rcarriga/nvim-notify',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
        },
        config = function()
            require('notify').setup({
                render = 'compact',
                stages = 'slide',
                timeout = 5000,
                background_colour = '#000000',
                icons = {
                    ERROR = '',
                    WARN = '',
                    INFO = '',
                    DEBUG = '',
                    TRACE = '✎',
                },
            })
            larp.fn.map('n', '<leader>fn', '<cmd>Telescope notify<cr>', { desc = 'Find Notify History' })
        end,
    },
    { 'petertriho/nvim-scrollbar' },
    {
        'stevearc/oil.nvim',
        opts = {
            delete_to_trash = true,
            use_default_keymaps = false,
            keymaps = {
                ['g?'] = 'actions.show_help',
                ['<CR>'] = 'actions.select',
                ['<C-5>'] = { 'actions.select', opts = { vertical = true }, desc = 'Open the entry in a vertical split' },
                ["<C-'>"] = { 'actions.select', opts = { horizontal = true }, desc = 'Open the entry in a horizontal split' },
                ['<C-t>'] = { 'actions.select', opts = { tab = true }, desc = 'Open the entry in new tab' },
                ['<C-p>'] = 'actions.preview',
                ['<C-c>'] = 'actions.close',
                ['<F5>'] = 'actions.refresh',
                ['-'] = 'actions.parent',
                ['_'] = 'actions.open_cwd',
                ['`'] = 'actions.cd',
                ['~'] = { 'actions.cd', opts = { scope = 'tab' }, desc = ':tcd to the current oil directory' },
                ['gs'] = 'actions.change_sort',
                ['gx'] = 'actions.open_external',
                ['g.'] = 'actions.toggle_hidden',
                ['g\\'] = 'actions.toggle_trash',
            },
            watch_for_changes = true,
            view_options = {
                show_hidden = true,
            },
            columns = {
                'icon',
                'mtime',
                'size',
                'permissions',
            },
            win_options = {
                winbar = "%{v:lua.require('oil').get_current_dir()}",
            },
        },
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
    },
    {
        'stevearc/overseer.nvim',
        opts = {},
        config = function()
            require('overseer').setup()
        end,
    },
    {
        'xiyaowong/transparent.nvim',
        config = true,
    },
    {
        'folke/trouble.nvim',
        branch = 'main', -- IMPORTANT!
        keys = {
            {
                '<leader>xx',
                '<cmd>Trouble diagnostics toggle<cr>',
                desc = 'Diagnostics (Trouble)',
            },
            {
                '<leader>xX',
                '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
                desc = 'Buffer Diagnostics (Trouble)',
            },
            {
                '<leader>cs',
                '<cmd>Trouble symbols toggle focus=false<cr>',
                desc = 'Symbols (Trouble)',
            },
            {
                '<leader>cl',
                '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
                desc = 'LSP Definitions / references / ... (Trouble)',
            },
            {
                '<leader>xL',
                '<cmd>Trouble loclist toggle<cr>',
                desc = 'Location List (Trouble)',
            },
            {
                '<leader>xQ',
                '<cmd>Trouble qflist toggle<cr>',
                desc = 'Quickfix List (Trouble)',
            },
        },
        opts = {}, -- for default options, refer to the configuration section for custom setup.
    },
    {
        'folke/twilight.nvim',
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
    },
    {
        'RRethy/vim-illuminate',
    },
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
    },
    -- Lua
    {
        'folke/zen-mode.nvim',
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        keys = {
            { '<leader>tz', '<cmd>ZenMode<cr>', desc = 'Toggle Zen Mode' },
        },
    },
}
