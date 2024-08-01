return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
        transparent_background = true,
        show_end_of_buffer = true,
        dim_inactive = {
            enabled = true,
            shade = "dark",
            percentage = 0.15,
        },
        integrations = {
            aerial = true,
            colorful_winsep = {
                enabled = true,
                color = "#f00",
            },
            flash = true,
            harpoon = true,
            hop = true,
        },

        styles = {
            sidebars = "transparent",
            floats = "transparent",
        },
    },
}
