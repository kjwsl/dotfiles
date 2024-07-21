vim.keymap.set("", "<leader>db", function ()
    local name = vim.api.nvim_buf_get_name(0)
    "<cmd>!g++ -o main " .. name
    end, {desc = "Comile Current Buffer", expr = true})
