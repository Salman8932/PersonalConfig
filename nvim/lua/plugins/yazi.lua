--@type LazySpec
return {
  "mikavilpas/yazi.nvim",
  version = "*", -- use the latest stable version
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  keys = {
    {
      "<leader>-",
      mode = { "n", "v" },
      "<cmd>Yazi<cr>",
      desc = "Open yazi at the current file",
    },
    {
      "<leader>cw",
      "<cmd>Yazi cwd<cr>",
      desc = "Open the file manager in nvim's working directory",
    },
    {
      "<c-up>",
      "<cmd>Yazi toggle<cr>",
      desc = "Resume the last yazi session",
    },
  },
  --@type YaziConfig | {}
  opts = {
    open_for_directories = false,
    change_neovim_cwd_on_close = true,
    keymaps = {
      show_help = "<f1>",
    },
    hooks = {
      yazi_closed_successfully = function(chosen_file, _config, _state)
        print("hook fired, chosen_file:", chosen_file)
        if chosen_file then
          local dir = vim.fn.fnamemodify(chosen_file, ":h")
          vim.cmd.lcd(dir)
        end
      end,
    },
  },
  init = function()
    vim.g.loaded_netrwPlugin = 1
  end,
}
