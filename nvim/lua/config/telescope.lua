local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<CR>"] = function(prompt_bufnr)
          local entry = action_state.get_selected_entry()
          actions.select_default(prompt_bufnr) -- opens the file, Telescope's normal Enter behavior

          if entry then
            local filepath = entry.path or entry.filename
            local dir = vim.fn.fnamemodify(filepath, ":h")
            vim.cmd.lcd(dir)
          end
        end,
      },
    },
  },
})
