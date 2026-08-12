-- Enable filetype plugins and indentation
vim.cmd("filetype plugin indent on")

-- Enable syntax highlighting
vim.cmd("syntax enable")

-- VimTeX settings
vim.g.vimtex_view_method = "general"
vim.g.vimtex_view_general_viewer = "C:\\Users\\charg\\AppData\\Local\\SumatraPDF\\SumatraPDF.exe"
vim.g.vimtex_view_general_options = "-reuse-instance -forward-search @tex @line @pdf"

vim.g.vimtex_compiler_method = "latexmk"

-- Set the local leader key
vim.g.maplocalleader = ","
