return {
    'nvim-telescope/telescope.nvim', version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        "echasnovski/mini.icons",
    },

    config = function()
        require("config.telescope")
    end,

        -- optional but recommended
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
}
