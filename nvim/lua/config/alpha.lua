local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
    "Welcome to Neovim",
    "Have a productive day",
}

dashboard.section.buttons.val = {
    dashboard.button(
        "e",
        "  New file",
        ":ene <CR>"
    ),

    dashboard.button(
        "f",
        "󰈞  Find file",
        ":Telescope find_files<CR>"
    ),

    dashboard.button(
        "q",
        "󰅚  Quit",
        ":qa<CR>"
    ),
}

dashboard.section.footer.val = {
    "Neovim loaded successfully"
}

alpha.setup(dashboard.opts)
