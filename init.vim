" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
filetype plugin indent on

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime

"Always show current position
set ruler

" Height of the command bar

set cmdheight=2

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" For regular expressions turn magic on
set magic

" Don't redraw while executing macros (good performance config)
set lazyredraw

set smarttab
set autoindent

set mouse=a

"语法高亮显示
syntax on

"显示行号
set number

" Show matching brackets when text indicator is over them
set showmatch 

"enable backspace
set backspace=indent,eol,start

"设置GVim字体
set guifont=LiberationMono\ 14
"隐藏GVim菜单栏
set guioptions-=m
"隐藏GVim工具栏
set guioptions-=T

" Use both cscope and ctags. `:set nocscopetag` to disable cscope
set cscopequickfix=s-,c-,d-,i-,t-,e-,a-

nnoremap <BS> X
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Automatically adjusts tab indent
Plug 'https://hub.fastgit.org/tpope/vim-sleuth.git'

Plug 'https://hub.fastgit.org/tpope/vim-unimpaired.git'

Plug 'https://hub.fastgit.org/vim-airline/vim-airline.git'
Plug 'https://hub.fastgit.org/vim-airline/vim-airline-themes.git'
let g:airline_theme='cool'
let g:airline#extensions#tabline#formatter = 'unique_tail'

Plug 'https://hub.fastgit.org/tomasiser/vim-code-dark.git'

" similar plugin: mhinz/vim-signify
Plug 'https://hub.fastgit.org/airblade/vim-gitgutter.git'

if has('nvim')
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
else
Plug 'Shougo/defx.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
endif

" Tags
Plug 'https://hub.fastgit.org/ludovicchabant/vim-gutentags.git'
Plug 'https://hub.fastgit.org/skywind3000/gutentags_plus.git'
source ~/vimrc.d/tag_config.vim

Plug 'https://hub.fastgit.org/bfrg/vim-cpp-modern.git'

" Enable function highlighting (affects both C and C++ files)
let g:cpp_function_highlight = 1

" Enable highlighting of C++11 attributes
let g:cpp_attributes_highlight = 1

" Highlight struct/class member variables (affects both C and C++ files)
let g:cpp_member_highlight = 1

" Put all standard C and C++ keywords under Vim's highlight group 'Statement'
" (affects both C and C++ files)
let g:cpp_simple_highlight = 1

" completion
Plug 'skywind3000/vim-auto-popmenu'
" enable this plugin for filetypes, '*' for all files.
let g:apc_enable_ft = {'*': 1}
" source for dictionary, current or other loaded buffers, see ':help cpt'
set cpt=.,k,w,b

Plug 'https://hub.fastgit.org/rust-lang/rust.vim.git', {'for': 'rust' }
let g:rustfmt_autosave = 1

Plug 'https://hub.fastgit.org/python-mode/python-mode.git', { 'for': 'python', 'branch': 'develop' }
Plug 'https://hub.fastgit.org/fatih/vim-go.git', { 'for': 'go', 'do': ':GoUpdateBinaries' }
Plug 'https://hub.fastgit.org/artur-shaik/vim-javacomplete2.git', { 'for': 'java'}

Plug 'https://hub.fastgit.org/ycm-core/YouCompleteMe.git'
source ~/vimrc.d/ycm_config.vim

" don't select the first item.
set completeopt=menu,menuone,noinsert,noselect

" suppress annoy messages.
set shortmess+=c

Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
let g:Lf_ShowDevIcons = 0

Plug 'jiangmiao/auto-pairs'
let g:AutoPairsFlyMode = 1

Plug 'Yohannfra/Vim-Goto-Header'
let g:goto_header_use_find = 1 " By default it's value is 0
let g:goto_header_open_in_new_tab = 1

Plug 'liuchengxu/vista.vim'
let g:vista_executive_for = {
  \ 'c': 'coc',
  \ 'cpp': 'coc',
  \ 'rust': 'coc',
  \ 'go': 'coc',
  \ 'python': 'coc',
  \ 'java': 'coc',
  \ }

" Use release branch (recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
source ~/vimrc.d/coc_config.vim

Plug 'dense-analysis/ale'
source ~/vimrc.d/ale_config.vim

Plug 'https://hub.fastgit.org/puremourning/vimspector.git'
let g:vimspector_enable_mappings = 'HUMAN'

" Initialize plugin system
call plug#end()

:packadd termdebug
let g:termdebug_wide=1

set t_Co=256
set t_ut=
:colorscheme codedark
