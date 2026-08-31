local telebuiltin = require("telescope.builtin")

vim.keymap.set("n", "<leader>sf", function()
	telebuiltin.find_files()
end, {
	desc = "[S]earch [F]iles",
})

vim.keymap.set("n", "<leader>scf", function()
	vim.cmd.cd(vim.fn.stdpath("config"))
	telebuiltin.find_files()
end, {
	desc = "[S]earch [C]onfig [F]iles",
})

vim.keymap.set("n", "<leader>sg", function()
	telebuiltin.live_grep()
end, {
	desc = "[S]earch [G]rep",
})

vim.keymap.set("n", "<leader>m", function()
	telebuiltin.marks({
		layout_strategy = "bottom_pane",
		previewer = false, -- hides the preview window to save space
		sorting_strategy = "ascending", -- puts typing prompt at the top of the bottom pane
		layout_config = {
			height = 10, -- uses exactly 10 lines of screen height
		},
	})
end)
