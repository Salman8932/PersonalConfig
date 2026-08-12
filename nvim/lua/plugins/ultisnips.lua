return {
  {
    "SirVer/ultisnips",
    dependencies = {
      "honza/vim-snippets",
    },
    init = function()
      vim.g.UltiSnipsExpandTrigger = "<tab>"
      vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
      vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>"

      -- Optional: your own snippets
      vim.g.UltiSnipsSnippetDirectories = { "UltiSnips" }
    end,
  },
}
