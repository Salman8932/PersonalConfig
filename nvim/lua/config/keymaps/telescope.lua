local telebuiltin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", function()
	telebuiltin.find_files()
	end, {
	desc = "find files",
})

vim.keymap.set("n", "<leader>ffc", function()
	vim.cmd.cd(vim.fn.stdpath("config"))
	telebuiltin.find_files()
	end, {
	desc = "go to config file directory",
})

vim.keymap.set("n", "<leader>gc", function()
	telebuiltin.live_grep()
	end, {
	desc = "Live grep search",
})

vim.keymap.set('n', '<leader>m', function()
  telebuiltin.marks({
    layout_strategy = 'bottom_pane',
    previewer = false, -- hides the preview window to save space
    sorting_strategy = 'ascending', -- puts typing prompt at the top of the bottom pane
    layout_config = {
      height = 10, -- uses exactly 10 lines of screen height
    },
  })
end)
