local function file_icon()
    local icon = MiniIcons.get("file", vim.fn.expand("%:t"))
    return icon
end

return {
    options = {
        theme = "gruvbox",
        component_separators = "",
        section_separators = "",
    },

    sections = {
        lualine_a = {
            {
                "mode",
                icon = "󰘳",
            },
        },

        lualine_b = {
            {
                "branch",
                icon = "",
            },
        },

        lualine_c = {
            file_icon,
            "filename",
        },

        lualine_x = {
            {
                "filetype",
                icon = "󰈔",
            },
        },

        lualine_y = {
            {
                "progress",
                icon = "󰦖",
            },
        },

        lualine_z = {
            {
                "location",
                icon = "󰍒",
            },
        },
    },
}
