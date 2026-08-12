return 
{

  "lervag/vimtex",
  lazy = false,     -- we don't want to lazy load VimTeX
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
    -- VimTeX configuration goes here, e.g.
    vim.g.tex_flavor = "latex"
    vim.g.vimtex_view_method = "general"
    vim.g.vimtex_view_general_viewer= "C:\\Users\\charg\\AppData\\Local\\SumatraPDF\\SumatraPDF.exe"
    vim.g.vimtex_compiler_method = "latexmk"

    vim.g.vimtex_compiler_latexmk_engines = {
  _ = "-lualatex",
}
       vim.g.tex_conceal = "abdmg"

    vim.opt.conceallevel = 1

  end
  
}
