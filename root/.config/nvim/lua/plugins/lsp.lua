local lsp = require('lsp.init')

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			'SmiteshP/nvim-navic',
			'p00f/clangd_extensions.nvim'
		},
		config = lsp.lspconfig,
	},
	{
		"linrongbin16/lsp-progress.nvim",
		config = require("lsp.lsp_progress").lsp_progress,
	},
	{
		"hedyhli/outline.nvim",
		lazy = true,
		cmd = { "Outline", "OutlineOpen" },
		opts = {
			-- Your setup opts here
		},
	},
	{
		'mrcjkb/rustaceanvim',
		version = '^4', -- Recommended
		ft = { 'rust' },
	}
}