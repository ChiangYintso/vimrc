vim.api.nvim_command('source ~/.vim/vimrc.d/plugin_setup.vim')

return {
	{
		"lervag/vimtex",
		ft = "tex",
		init = function()
			vim.api.nvim_command('source ~/.vim/vimrc.d/latex.vim')
		end
	},
	-- https://github.com/Robitx/gp.nvim
	{
		'madox2/vim-ai',
		init = function()
			vim.api.nvim_command('source ~/.vim/vimrc.d/ai.vim')
		end
	},
	-- Ref: https://github.com/ibhagwan/fzf-lua
	{ "junegunn/fzf",     build = "./install --bin" },
	{
		'junegunn/fzf.vim',
		dependencies = { 'junegunn/fzf' },
		init = function()
			vim.api.nvim_command('source ~/.vim/vimrc.d/fzf.vim')
		end
	},
	{
		'voldikss/vim-floaterm',
		init = function()
			vim.api.nvim_command('source ~/.vim/vimrc.d/floaterm.vim')
		end
	},
	{
		'voldikss/fzf-floaterm',
		dependencies = {
			'junegunn/fzf',
			'voldikss/vim-floaterm',
		},
	},
	{
		'skywind3000/asynctasks.vim',
		dependencies = {
			'skywind3000/asyncrun.vim'
		},
		init = function()
			vim.api.nvim_command('source ~/.vim/vimrc.d/asynctasks.vim')
		end
	},
	'justinmk/vim-sneak',
	'ap/vim-css-color',
	{
		'LunarWatcher/auto-pairs',
		config = function()
			-- 设置特定于文件类型的自动配对
			vim.g.AutoPairs = vim.fn['autopairs#AutoPairsDefine']({
				{ open = "<", close = ">", filetype = { "html" } }
			})
			-- 设置 vifm 的自动配对与 vim 相同
			vim.g.AutoPairsLanguagePairs['vifm'] = vim.g.AutoPairsLanguagePairs['vim']
		end
	},
	'markonm/traces.vim',
	{
		'jiangyinzuo/vim-visual-multi',
		branch = 'master',
	},
	'vim-test/vim-test',
	'simnalamburt/vim-mundo',
	'aperezdc/vim-template',
	'szw/vim-maximizer',
	'tpope/vim-commentary',
	'tpope/vim-characterize',
	{
		'brooth/far.vim',
		cmd = { 'Far', 'Farf', 'Farp', 'Farr' }
	},
	'preservim/vimux',
	'honza/vim-snippets',
	'voldikss/vim-translator',
	'romainl/vim-qf',
	{
		'mechatroner/rainbow_csv',
		ft = 'csv',
	},
	'jiangyinzuo/open-gitdiff.vim',
	'tpope/vim-surround',
	'tpope/vim-eunuch',
	'AndrewRadev/splitjoin.vim',
	'tpope/vim-abolish',
	'arthurxavierx/vim-caser',
	'preservim/tagbar',
	'liuchengxu/vista.vim',
	'samoshkin/vim-mergetool',
	'godlygeek/tabular',
	{ 'axvr/org.vim',     ft = 'org' },
	{ 'kaarmu/typst.vim', ft = 'typst' },
	'airblade/vim-gitgutter',
	'tpope/vim-fugitive',
	'junegunn/gv.vim',
	{ 'alepez/vim-gtest',     ft = { 'c', 'cpp', 'cuda' } },
	{ 'ojroques/vim-oscyank', branch = 'main' },
	{ 'whonore/Coqtail',      ft = 'coq' }
}
