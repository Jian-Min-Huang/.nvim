local config = vim.fn.expand("~/.nvim/.markdownlint-cli2.yaml")

return {
	{
		"mfussenegger/nvim-lint",
		optional = true,
		opts = {
			linters = {
				["markdownlint-cli2"] = {
					prepend_args = { "--config", config },
				},
			},
		},
	},
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			formatters = {
				["markdownlint-cli2"] = {
					prepend_args = { "--config", config },
				},
			},
		},
	},
}
