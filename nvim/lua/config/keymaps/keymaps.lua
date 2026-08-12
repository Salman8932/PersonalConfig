-- Moving around 

vim.keymap.set("n", "<leader>tv", "<cmd>vert terminal<CR>", {
	desc = "Vertical terminal",
})

vim.keymap.set("n", "<leader>th", "<cmd>hor terminal<CR>", {
	desc = "Horizontal terminal",
})

vim.keymap.set("n", "<leader>sh", "<cmd>split<CR>", {
	desc = "Split Horizontal",
})

vim.keymap.set("n", "<leader>sv", "<cmd>vert split<CR>", {
	desc = "Split vertical",
})



-- Copy and paste

vim.keymap.set("x", "<leader>y", [["+y]], {
	desc = "mega yank",
})

vim.keymap.set("x", "<leader>x", [["+x]], {
	desc = "mega cut",
})

vim.keymap.set({"n", "x"}, "<leader>p", [["+p]], {
	desc = "mega paste",
})

-- directory

vim.keymap.set("n", "<leader>dc", function()
	vim.cmd.cd(vim.fn.stdpath("config"))
	end, {
	desc = "go to config file directory",
})

vim.keymap.set("n", "<leader>dd", function()
	vim.cmd.cd("~/Documents/")
	end, {
	desc = "go to Documents directory",
})

vim.keymap.set("n", "<leader>dw", function()
	vim.cmd.cd(vim.fn.expand("%:p:h"))
	end, {
	desc = "go to working file directory",
})

vim.keymap.set("n", "<leader>dl", function()
	vim.cmd.cd("~/current_course/")
	end, {
	desc = "go to current_course directory",
})


-- Miscellaneous

vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], {silent = true })
