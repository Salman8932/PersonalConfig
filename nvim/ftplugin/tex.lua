-- ~/.config/nvim/ftplugin/tex.lua
vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us"
vim.keymap.set("i", "<C-l>", "<c-g>u<Esc>[s1z=`]a<c-g>u", { buffer = true })
