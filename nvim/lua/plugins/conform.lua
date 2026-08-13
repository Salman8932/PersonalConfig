return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			-- Conform will run multiple formatters sequentially
			python = { "isort", "black" },
			-- You can customize some of the format options for the filetype (:help conform.format)
			-- Conform will run the first available formatter
			javascript = { "prettierd", "prettier", stop_after_first = true },

			ps1 = { "powershell" },
		},

		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},

		formatters = {
			powershell = {
				command = "pwsh",
				args = {
					"-NoProfile",
					"-Command",
					"$input | Invoke-Formatter",
				},
				stdin = true,
			},
		},
	},
}
