vim.api.nvim_create_user_command("ReloadCourse", function()
  vim.opt.rtp:append(vim.fn.expand("~/current_course"))
  vim.cmd("set filetype=" .. vim.bo.filetype)

  if vim.fn.exists("*UltiSnips#RefreshSnippets") == 1 then
    vim.fn["UltiSnips#RefreshSnippets"]()
  end

  print("Course snippets reloaded")
end, {})
