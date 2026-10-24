local config = vim.fn.expand("~/.nvim/ktlint.editorconfig")

return {
	{
		"mfussenegger/nvim-lint",
		optional = true,
		opts = {
			linters = {
				ktlint = {
					prepend_args = { "--editorconfig=" .. config },
				},
			},
		},
	},
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			formatters = {
				ktlint = {
					prepend_args = { "--editorconfig=" .. config },
				},
			},
		},
	},
}
