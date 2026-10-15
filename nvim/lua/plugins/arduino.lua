return {
	"yuukiflow/Arduino-Nvim",
	ft = "arduino",
	opts = {},
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"neovim/nvim-lspconfig",
	},
	config = function(_, opts)
		require("Arduino-Nvim").setup(opts)

		vim.filetype.add({ extension = { ino = "arduino" } })

		-- base + cmp capabilities, minus semantic tokens
		local caps = vim.lsp.protocol.make_client_capabilities()
		local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
		if ok then
			caps = vim.tbl_deep_extend("force", caps, cmp_lsp.default_capabilities())
		end
		caps.textDocument.semanticTokens = nil
		caps.workspace.semanticTokens = nil
		-- the Go LSP parser in arduino-language-server can't handle InsertReplaceEdit
		caps.textDocument.completion.completionItem.insertReplaceSupport = false

		vim.lsp.config("arduino_language_server", {
			cmd = {
				"arduino-language-server",
				"-cli",
				"arduino-cli",
				"-cli-config",
				"C:/Users/charg/AppData/Local/Arduino15/arduino-cli.yaml",
				"-clangd",
				"C:/Users/charg/scoop/apps/llvm/current/bin/clangd.exe",
				"-fqbn",
				"arduino:avr:uno",
			},
			filetypes = { "arduino" },
			root_dir = function(bufnr, on_dir)
				on_dir(vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)))
			end,
			capabilities = caps,
			on_attach = function(client, bufnr)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentOnTypeFormattingProvider = nil
				vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
			end,
		})

		vim.lsp.enable("arduino_language_server")
	end,
}
