--- Uncomment the two plugins below if you want to manage the language servers from neovim

return {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
        { 'neovim/nvim-lspconfig' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/nvim-cmp' },
        { 'L3MON4D3/LuaSnip' },
        { 'williamboman/mason.nvim' },
        { 'williamboman/mason-lspconfig.nvim' },
    },
    config = function()
        local lsp_zero = require('lsp-zero')

        lsp_zero.setup({})

        lsp_zero.on_attach(function(client, bufnr)
            lsp_zero.default_keymaps({ buffer = bufnr, exclude = { '<F2>', '<F3>','<F4>'} })
        end)

        require('mason').setup({})
        require('mason-lspconfig').setup({
            ensure_installed = {},
            handlers = {
                function(server_name)
                    require('lspconfig')[server_name].setup({})
                end,
            },
        })
    end

}
