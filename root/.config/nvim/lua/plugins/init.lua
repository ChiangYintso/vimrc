local plugins_setup = require('plugins_setup')

local lualine = {
	'nvim-lualine/lualine.nvim',
	config = plugins_setup.lualine,
}
if vim.g.vimrc_lsp == 'nvim-lsp' then
	lualine.dependencies = { 
		"neovim/nvim-lspconfig",
		"linrongbin16/lsp-progress.nvim",
	}
end

return {
	{
		"ishan9299/nvim-solarized-lua",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- load the colorscheme here
			vim.cmd([[colorscheme solarized]])
		end,
	},
	{
		'nvim-tree/nvim-web-devicons'
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = plugins_setup.nvm_treesitter,
	},
	{
		"nvim-telescope/telescope.nvim",
		lazy = true,
		keys = {
			"<leader>fb",
			"<leader>ff",
			"<leader>fh",
			"<leader>ft",
			"<leader>rg",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
			"nvim-telescope/telescope-media-files.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = plugins_setup.telescope,
	},
	{
		"williamboman/mason.nvim",
		config = plugins_setup.mason,
	},
	lualine,
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		dependencies = {
			{ "github/copilot.vim" }, -- or github/copilot.vim
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		opts = {
			debug = true, -- Enable debugging
			-- See Configuration section for rest
		},
		-- See Commands section for default commands if you want to lazy load on them
	},
}