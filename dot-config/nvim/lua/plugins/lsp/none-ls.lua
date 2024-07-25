return {
    "nvimtools/none-ls.nvim",
    dependencies = {
        "jose-elias-alvarez/null-ls.nvim",
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                null_ls.builtins.completion.spell,
                null_ls.builtins.completion.luasnip,
                null_ls.builtins.completion.tags,
                null_ls.builtins.code_actions.gitsigns,
                null_ls.builtins.diagnostics.eslint,
                null_ls.builtins.diagnostics.buf,
                null_ls.builtins.diagnostics.buildifier,
                null_ls.builtins.diagnostics.checkmake,
                null_ls.builtins.diagnostics.clang_check,
                null_ls.builtins.diagnostics.cmake_lint,
                null_ls.builtins.diagnostics.cppcheck,
                null_ls.builtins.diagnostics.luacheck,
                null_ls.builtins.diagnostics.markdownlint,
                null_ls.builtins.diagnostics.markdownlint_cli2,
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.formatting.clang_format,
                null_ls.builtins.formatting.cmake_format,
                null_ls.builtins.formatting.prettier,
            }
        })
    end
}
