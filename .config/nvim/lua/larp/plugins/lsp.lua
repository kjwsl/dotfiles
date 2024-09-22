return {
    {
        'ray-x/lsp_signature.nvim',
        event = 'VeryLazy',
        config = function()
            require('lsp_signature').setup({
                bind = true,
                handle_opts = {
                    border = 'rounded',
                },
            })
        end,
    },
    { 'rafamadriz/friendly-snippets' },
    {

        'L3MON4D3/LuaSnip',
        -- follow latest release.
        version = 'v2.*', -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = 'make install_jsregexp',
        dependencies = {
            'saadparwaiz1/cmp_luasnip',
        },
    },
    {
        'stevearc/conform.nvim',
        opts = {},
        config = function()
            require('conform').setup({
                formatters_by_ft = {
                    lua = { 'stylua' },
                    python = { 'black' },
                    rust = { 'rustfmt' },
                    c = { 'clang_format' },
                    cpp = { 'clang_format' },
                    cmake = { 'cmake_format' },
                    nix = { 'nixpkgs_fmt', 'nixfmt' },
                    markdown = { 'markdownfmt', 'markdownlint', 'markdownlint-cli2' },
                    xml = { 'xmlformat' },
                    text = { 'autocorrect' },
                    ['*'] = { 'autocorrect', 'codespell' },
                    ['_'] = { 'trim_whitespace' },
                },
                default_format_opts = {
                    lsp_format = 'fallback',
                },
                format_after_save = {
                    lsp_format = 'fallback',
                    timeout_ms = 500,
                },
                -- Conform will notify you when no formatters are available for the buffer
                notify_no_formatters = true,
            })
larp.fn.map('n', '<leader>cf', "<cmd>lua require('conform').format()<cr>")
        end,
    },

    {
        'mrcjkb/rustaceanvim',
        version = '^5', -- Recommended
        lazy = false, -- This plugin is already lazy
    },

    {
        'VonHeikemen/lsp-zero.nvim',
        event = 'BufEnter',
        branch = 'v4.x',
        dependencies = {
            { 'neovim/nvim-lspconfig' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-nvim-lua' },
            { 'rafamadriz/friendly-snippets' },
            { 'L3MON4D3/LuaSnip' },
            { 'onsails/lspkind.nvim' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'mrcjkb/rustaceanvim' },
        },
        -- TODO: Have sources show up in the completion menu. The default one does, but lspkind overwrites it.
        config = function()
            local lsp_zero = require('lsp-zero')
            local cmp = require('cmp')
            local cmp_action = lsp_zero.cmp_action()
            local cmp_format = lsp_zero.cmp_format({ details = true })
            cmp_format.format = require('lspkind').cmp_format({
                mode = 'symbol_text',
                maxwidth = 50,
                ellipsis_char = '...',
                show_labelDetails = true, -- show labelDetails in menu. Disabled by default

                -- The function below will be called before any actual modifications from lspkind
                -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
                before = function(entry, vim_item)
                    return vim_item
                end,
            })

            require('luasnip.loaders.from_vscode').lazy_load()
            cmp.setup({
                preselect = 'item',
                completion = {
                    completeopt = 'menu,menuone,noinsert',
                },

                sources = {
                    { name = 'nvim_lsp' },
                    {
                        name = 'luasnip',
                        option = {
                            use_show_condition = false,
                            show_autosnippets = true,
                        },
                    },
                    {
                        name = 'buffer',
                        option = {
                            keyword_pattern = [[\k+]],
                            get_bufnrs = function()
                                return vim.api.nvim_list_bufs()
                            end,
                        },
                    },
                    { name = 'neorg' },
                    sorting = {
                        comparators = {
                            function(...)
                                return require('cmp-buffer').compare_locality(...)
                            end,
                            cmp.config.compare.offset,
                            cmp.config.compare.exact,
                            cmp.config.compare.score,
                            cmp.config.compare.kind,
                            cmp.config.compare.length,
                            cmp.config.compare.order,
                            cmp.config.compare.alphabet,
                            cmp.config.compare.substr,
                            cmp.config.compare.fuzzy,
                        },
                    },
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                formatting = cmp_format,

                mapping = cmp.mapping.preset.insert({
                    ['<c-f>'] = cmp_action.luasnip_jump_forward(),
                    ['<c-b>'] = cmp_action.luasnip_jump_backward(),
                }),
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                -- formatting = {
                --     fields = { 'abbr', 'kind', 'menu' },
                --     format = require('lspkind').cmp_format({
                --         mode = 'symbol', -- show only symbol annotations
                --         maxwidth = 50, -- prevent the popup from showing more than provided characters
                --         ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
                --     }),
                -- },
                -- mapping = {
                --     ['<C-n>'] = cmp.mapping.select_next_item(),
                --     ['<C-p>'] = cmp.mapping.select_prev_item(),
                --     ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                --     ['<C-f>'] = cmp.mapping.scroll_docs(4),
                --     ['<C-Space>'] = cmp.mapping.complete(),
                --     ['<C-e>'] = cmp.mapping.close(),
                --     ['<C-y>'] = cmp.mapping.confirm({
                --         behavior = cmp.ConfirmBehavior.Insert,
                --         select = true,
                --     }),
                -- },
                -- snippet = {
                --     expand = function(args)
                --         require('luasnip').lsp_expand(args.body)
                --     end,
                -- },
            })

            -- LSP Setup

            lsp_zero.setup({})
            lsp_zero.on_attach(function(client, bufnr)
                lsp_zero.default_keymaps({ buffer = bufnr, preserve_mappings = false })
            end)

            lsp_zero.extend_lspconfig({
                capabilities = require('cmp_nvim_lsp').default_capabilities(),
            })

            vim.g.rustaceanvim = {
                server = {
                    capabilities = lsp_zero.get_capabilities(),
                },
            }

            require('mason').setup({
                ui = {
                    icons = {
                        package_installed = '✓',
                        package_pending = '➜',
                        package_uninstalled = '✗',
                    },
                },
            })
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'lua_ls',
                    'rust_analyzer',
                    'clangd',
                    'bashls',
                    'html',
                    'cssls',
                    'jsonls',
                    'yamlls',
                    'ts_ls',
                    'bashls',
                    'pylsp',
                    'pylyzer',
                    'pyright',
                    'rust_analyzer',
                    'clangd',
                    'cmake',
                    'kotlin_language_server',
                    'vimls',
                    'marksman',
                    'graphql',
                    'lua_ls',
                },
                automatic_installation = true,
                handlers = {
                    function(server_name)
                        require('lspconfig')[server_name].setup({})
                    end,
                    lua_ls = function()
                        require('lspconfig').lua_ls.setup({
                            on_init = function(client)
                                lsp_zero.nvim_lua_settings(client, {})
                            end,
                        })
                    end,
                    rust_analyzer = lsp_zero.noop,
                },
            })
        end,
    },
    {
        'nvimdev/lspsaga.nvim',
        event = 'LspAttach',
        config = function()
            require('lspsaga').setup({
                lightbulb = {
                    enable = false,
                },
                symbol_in_winbar = {
                    enable = true,
                },
                outline = {
                    auto_preview = true,
                    auto_close = true,
                    detail = true,
                },
            })
            require('lspsaga.symbol.winbar').get_bar()
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter', -- optional
            'nvim-tree/nvim-web-devicons', -- optional
        },
    },
    { 'onsails/lspkind.nvim' },
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = true,
        -- use opts = {} for passing setup options
        -- this is equivalent to setup({}) function
    },
    {
        'kevinhwang91/nvim-ufo',
        dependencies = { 'kevinhwang91/promise-async' },
        init = function()
            vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
            vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
        end,
        config = function()
            local ufo = require('ufo')
            -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
            larp.fn.map('n', 'zR', ufo.openAllFolds)
            larp.fn.map('n', 'zM', ufo.closeAllFolds)
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            }
            local language_servers = require('lspconfig').util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
            for _, ls in ipairs(language_servers) do
                require('lspconfig')[ls].setup({
                    capabilities = capabilities,
                    -- you can add other fields for setting up lsp server in this table
                })
            end
            local handler = function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local suffix = (' 󰁂 %d '):format(endLnum - lnum)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hlGroup = chunk[2]
                        table.insert(newVirtText, { chunkText, hlGroup })
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        -- str width returned from truncate() may less than 2nd argument, need padding
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end
                table.insert(newVirtText, { suffix, 'MoreMsg' })
                return newVirtText
            end

            ufo.setup({
                fold_virt_text_handler = handler,
            })
        end,
    },
    {
        'stevearc/aerial.nvim',
        opts = {},
        -- Optional dependencies
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons',
        },
        config = function()
            local aerial = require('aerial')
            aerial.setup({
                filter_kind = false,
                max_width = { 100, 0.2 },
                -- ignore = {
                --   filetype = {
                --     'oil',
                --     'dashboard',
                --   },
                -- },
                attach_mode = 'window',
                autojump = true,
                show_guides = true,
                lsp = {
                    diagnostics_trigger_update = true,
                },
            })
        end,
    },
}
