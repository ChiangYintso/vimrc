" run
" :source %
" to update
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Plug 'LunarWatcher/auto-pairs'
" let g:AutoPairsMapBS = 1

" similar Plugin: Plug 'easymotion/vim-easymotion'
Plug 'justinmk/vim-sneak'
let g:sneak#label = 1
" default s: delete [count] charaters and start insert
map s <Plug>Sneak_s
map S <Plug>Sneak_S
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

Plug 'markonm/traces.vim'
Plug 'tomasiser/vim-code-dark'

Plug 'voldikss/vim-floaterm'
let g:floaterm_width = 0.8
let g:floaterm_height = 0.8

" Plug 'MattesGroeger/vim-bookmarks'

" Plug 'ojroques/vim-oscyank', {'branch': 'main'}
" vnoremap <leader>c :OSCYank<CR>

Plug 'airblade/vim-gitgutter'

if executable('python3')
  source ~/vimrc.d/leaderf.vim
endif

if executable('fzf')
  source ~/vimrc.d/fzf.vim
endif

if executable('node')
  source ~/vimrc.d/coc.vim
endif

source ~/vimrc.d/cpp.vim
" source ~/vimrc.d/go.vim
source ~/vimrc.d/markdown.vim
source ~/vimrc.d/latex.vim

Plug 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"

Plug 'honza/vim-snippets'

source ~/vimrc.d/asynctasks.vim

" Initialize plugin system
call plug#end()

colorscheme codedark
