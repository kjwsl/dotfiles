return {
    "williamboman/mason.nvim",
    keys = {
        { "<leader>m", ":Mason<CR>", noremap = true, silent = true, desc = "Mason" }
    },
    config = function()
        require("mason").setup()
    end
}
