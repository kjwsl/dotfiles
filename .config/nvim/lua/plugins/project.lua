return {
    "ahmedkhalf/project.nvim",
    dependencies = {
        'nvim-telescope/telescope.nvim',
    },
    init = function()
        local telescope = require('telescope')
        telescope.load_extension("projects")
    end
}
