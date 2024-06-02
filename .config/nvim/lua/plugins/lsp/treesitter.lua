return {
    "nvim-treesitter/nvim-treesitter",
    opts = {
        ensure_installed = {
            "c", "cpp", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "python", "javascript", "kotlin", "json",
        },
        auto_install = true,
        highlight = {
            enable = true,
        }
    }
}
