require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "pyright" },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Lua
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})
vim.lsp.enable("lua_ls")

-- Python
vim.lsp.config("pyright", {
  capabilities = capabilities,
})
vim.lsp.enable("pyright")
