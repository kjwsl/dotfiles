return {
    "ahmedkhalf/project.nvim",
    enabled = false,
    dependencies = {
        'nvim-telescope/telescope.nvim',
    },
    init = function()
        local telescope = require('telescope')
        telescope.load_extension("projects")
    end
}
