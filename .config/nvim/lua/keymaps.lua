local function map(mode, lhs, rhs, opts)
    local default_opts = { silent = true, noremap = false }

    if opts ~= nil then
        for k, v in pairs(opts) do default_opts[k] = v end
    end

    vim.keymap.set(mode, lhs, rhs, default_opts)
end


-- Windows
map("", "<leader>wh", "<C-w>h", { desc = "Move to Left Window" })
map("", "<leader>wj", "<C-w>j", { desc = "Move to Down Window" })
map("", "<leader>wk", "<C-w>k", { desc = "Move to Up Window" })
map("", "<leader>wl", "<C-w>l", { desc = "Move to Right Window" })
map("", "<leader>sh", ":vsplit<CR>", { desc = "Split Window to the Left" })
map("", "<leader>sj", ":split<CR><C-w>j", { desc = "Split Window to the Bottom" })
map("", "<leader>sk", ":split<CR>", { desc = "Split Window to the Top" })
map("", "<leader>sl", ":vsplit<CR><C-w>l", { desc = "Split Window to the Right" })
map("", "<leader>wc", "<C-w>c", { desc = "Close Window" })
map("", "<leader>wo", "<C-w>o", { desc = "Maximize Window" })

-- General
map("", "<leader>qq", ":confirm qa<CR>", { desc = "Exit NeoVim" })

-- Editing
map("i", "<C-C>", "<ESC>")
map("v", "J", function ()
    return ":m '>" .. (vim.v.count > 1 and vim.v.count or 1) .."<CR>gv=gv"
end, { expr = true, desc = "Move Selected Line Down" })

map("v", "K", function ()
    return ":m '<" .. (vim.v.count > 1 and -vim.v.count-1 or -2) .."<CR>gv=gv"
end, { expr = true, desc = "Move Selected Line Up" })


-- File
map("n", "<leader>bw", "<CMD>w<CR>", {desc = "[B]uffer [W]rite"})
map("i", "kjl", "<Esc>")

-- Palindrome Support! lol
map("v", "<leader>lp", "y:set revins<CR>gvA<C-r>\"<Esc>x:set norevins<CR>", { desc = "Palindromify Selection" })
