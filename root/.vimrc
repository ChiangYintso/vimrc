if has('vim_starting')
  set viminfofile=$HOME/.vim/.viminfo
endif

set nocp "no Vi-compatible
set history=500 " Sets how many lines of history VIM has to remember

" Enable filetype plugins
filetype indent on
filetype plugin on

syntax on "语法高亮显示
set encoding=utf-8
set fileencoding=utf-8
" vim自动探测fileencodeing的顺序列表
set fileencodings=utf-8,ucs-bom,gbk,cp936,gb2312,gb18030
set termencoding=utf-8
set ff=unix
set number "显示行号
set showmatch  " 输入），}时，光标会暂时的回到相匹配的（，{。如果没有相匹配的就发出错误信息的铃声
set backspace=indent,eol,start "indent: BS可以删除缩进; eol: BS可以删除行末回车; start: BS可以删除原先存在的字符
set hidden " 未保存文本就可以隐藏buffer
set cmdheight=1 " cmd行高1
set wildmenu " command自动补全时显示菜单
set wildmode=list:full " command自动补全时显示整个列表
set wildignore=.git,build
set path=.,, " 当前目录和当前文件所在目录
set updatetime=700 " GitGutter更新和自动保存.swp的延迟时间
set timeoutlen=3000 " key map 超时时间

set autowrite " 自动保存
set cursorline " 高亮当前行

set hlsearch " Highlight search results
set incsearch " 输入搜索内容时就显示搜索结果
set magic "模式匹配时 ^ $ . * ~ [] 具有特殊含义
set lazyredraw " 不要在宏的中间重绘屏幕。使它们更快完成。

set nobackup       "no backup files
set nowritebackup  "only in case you don't want a backup file while editing
set noswapfile     "no swap files

" 会话不保存options
set sessionoptions-=options
""""""""""""""""""""""""""""""
"indent and tab
""""""""""""""""""""""""""""""
set smarttab
set autoindent " 跟随上一行的缩进方式
set smartindent " 以 { 或cinword变量开始的行（if、while...），换行后自动缩进

augroup cpp
	autocmd!
	autocmd FileType c,cpp setlocal equalprg=clang-format
augroup end

augroup indent2
	autocmd!
	autocmd FileType c,cpp,vim,tex,markdown,html,sh,zsh,json,lua setlocal tabstop=2 shiftwidth=2 softtabstop=2
augroup end
augroup indent4
	autocmd!
	autocmd FileType python,go,rust,java setlocal tabstop=4 shiftwidth=4 softtabstop=4
augroup end

" https://github.com/timakro/vim-yadi/blob/main/plugin/yadi.vim
function s:DetectIndent()
	let tabbed = 0
	let spaced = 0
	let indents = {}
	let lastwidth = 0
	" get the last 300 lines
	let l:first_line = max([0, line('$')-300])
	for line in getline(l:first_line, line('$'))
		if line[0] == "\t"
			let tabbed += 1
		else
			" The position of the first non-space character is the
			" indentation width.
			let width = match(line, "[^ ]")
			if width != -1
				if width > 0
					let spaced += 1
				endif
				let indent = width - lastwidth
				if indent >= 2 " Minimum indentation is 2 spaces
					let indents[indent] = get(indents, indent, 0) + 1
				endif
				let lastwidth = width
			endif
		endif
	endfor

	let total = 0
	let max = 0
	let winner = -1
	for [indent, n] in items(indents)
		let total += n
		if n > max
			let max = n
			let winner = indent
		endif
	endfor

	if tabbed > spaced*4 " Over 80% tabs
		" echo "Detected indent: tab"
		setlocal noexpandtab shiftwidth=0 softtabstop=0
	elseif spaced > tabbed*4 && max*5 > total*3
		" Detected over 80% spaces and the most common indentation level makes
		" up over 60% of all indentations in the file.
		" echo "Detected indent: " . winner . " spaces"
		setlocal expandtab
		let &shiftwidth=winner
		let &softtabstop=winner
	endif
endfunction

autocmd FileType * call s:DetectIndent()

let g:RootMarks = ['.git', '.root', '.noterepo', '.coderepo']

let s:has_vimrcd = isdirectory(expand('~/vimrc.d'))
if exists("g:vscode")
	let g:loaded_netrw = 1
	let g:loaded_netrwPlugin = 1
	if s:has_vimrcd
		source ~/vimrc.d/plugin.vim
	endif
	finish	
endif

" 显示空白字符
" https://codepoints.net/U+23B5
if has('nvim') || v:version >= 801
	set listchars=eol:⏎,tab:␉─▷,trail:␠,nbsp:⎵,extends:»,precedes:«
else
	set listchars=eol:⏎,tab:␉─,trail:␠,nbsp:⎵,extends:»,precedes:«
end
set list

set guifont=Monospace\ Regular\ 20
set mouse=a

if has("nvim-0.5.0") || has("patch-8.1.1564")
	set signcolumn=number " 合并git状态与行号
elseif v:version >= 801
	set signcolumn=yes " 同时显示git状态和行号
endif

if v:version >= 801
	" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
	" Set to auto read when a file is changed from the outside
	set autoread
	" Triger `autoread` when files changes on disk
	" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
	" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
	autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
				\ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif

	" Notification after file change
	" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
	autocmd FileChangedShellPost *
				\ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl Noneau FocusGained,BufEnter * checktime
endif

""""""""""""""""""""""""""""""

if has("patch-8.1.0360")
	set diffopt+=internal,algorithm:patience
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""" termdebug
set t_Co=256
set t_ut=
hi debugPC term=reverse ctermbg=4 guibg=darkblue

if has('nvim') || v:version >= 801
	autocmd Filetype c,cpp packadd termdebug
	let g:termdebug_wide = 1
endif

"""""""""""""""""""""""""""""""""""""""""""""""""" Netrw Plugin
"  open explorer :Ex :Sex :Vex
" close explorer :Rex
"
" do not load netrw
" let g:loaded_netrw = 1
" let g:loaded_netrwPlugin = 1
let g:netrw_browse_split = 0 " open the file using netrw buffer
let g:netrw_liststyle = 3 " tree style listing
let g:netrw_preview = 0 " preview window horizontally
let g:netrw_browsex_viewer="start"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Commenting blocks of code.
augroup commenting_blocks_of_code
	autocmd!
	autocmd FileType c,cpp,java,scala 	                   let b:comment_leader = '// '
	autocmd FileType sh,ruby,python,conf,fstab,gitconfig   let b:comment_leader = '# '
	autocmd FileType tex                                   let b:comment_leader = '% '
	autocmd FileType mail                                  let b:comment_leader = '> '
	autocmd FileType vim                                   let b:comment_leader = '" '
	autocmd FileType lua                                   let b:comment_leader = '-- '
augroup end

" https://stackoverflow.com/questions/1676632/whats-a-quick-way-to-comment-uncomment-lines-in-vim
" A sed (s/what/towhat/where) command changing ^ (start of line) to the correctly set comment character based on the type of file you have opened 
" As for the silent thingies they just suppress output from commands. 
" :nohlsearch stops it from highlighting the sed search
noremap <silent> <leader>cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> <leader>cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

function GetVisualSelection()
	" https://stackoverflow.com/questions/1533565/how-to-get-visually-selected-text-in-vimscript
	" Why is this not a built-in Vim script function?!
	let [line_start, column_start] = getpos("'<")[1:2]
	let [line_end, column_end] = getpos("'>")[1:2]
	let lines = getline(line_start, line_end)
	if len(lines) == 0
		return ''
	endif
	let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
	let lines[0] = lines[0][column_start - 1:]
	return join(lines, "\n")
endfunction

function ShowQuickfixListIfNotEmpty()
	let length = len(getqflist())
	if length > 1
		copen
	elseif length == 1
		copen
		ccl
	elseif length == 0
		echo 'empty quickfix list'
	endif
endfunction

function VimGrepFindWord(word)
	if &filetype == 'c' || &filetype == 'cpp'
		let extention = '**/*.c **/*.cpp **/*.cc **/*.h'
	elseif &filetype == 'python'
		let extention = '**/*.py'
	elseif &filetype == 'go'
		let extention = '**/*.go'
	else
		let extention = '**'
	endif
	" <pattern>: 匹配整个单词
	silent exe 'silent! vimgrep' '/\<'.a:word.'\>/' extention
	call ShowQuickfixListIfNotEmpty()
endfunction

nnoremap <silent> <leader>fw :call VimGrepFindWord(expand("<cword>"))<CR>
vnoremap <silent> <leader>fw :call VimGrepFindWord(GetVisualSelection())<CR>
command! -nargs=1 Vimfw call VimGrepFindWord(<q-args>)

function VimGrepFindType(word)
	call setqflist([])
	" <pattern>: 匹配整个单词
	if &filetype == 'c'	
		silent exe 'silent! vimgrepadd' '/\<struct '.a:word.'\>/' '**/*.c' '**/*.h'
		silent exe 'silent! vimgrepadd' '/\<union '.a:word.'\>/' '**/*.c' '**/*.h'
	elseif &filetype == 'cpp'
		silent! exe 'silent! vimgrepadd' '/\<struct '.a:word.'\>/' '**/*.cpp' '**/*.cc' '**/*.h'
		silent! exe 'silent! vimgrepadd' '/\<union '.a:word.'\>/' '**/*.cpp' '**/*.cc' '**/*.h'
		silent! exe 'silent! vimgrepadd' '/\<class '.a:word.'\>/' '**/*.cpp' '**/*.cc' '**/*.h'
	elseif &filetype == 'python'
		silent exe 'silent! vimgrepadd' '/\<class '.a:word.'\>/' '**/*.py'
	elseif &filetype == 'go'
		silent exe 'silent! vimgrepadd' '/\<type '.a:word.'\>/' '**/*.go'
	else
		echo 'unsupport filetype: '.&filetype
		return
	endif
	call ShowQuickfixListIfNotEmpty()
endfunction

nnoremap <silent> <leader>fy :call VimGrepFindType(expand("<cword>"))<CR>
vnoremap <silent> <leader>fd :call VimGrepFindType(GetVisualSelection())<CR>
command! -nargs=1 Vimfy call VimGrepFindType(<q-args>)

function VimGrepFindDefinition(word)
	call setqflist([])
	if &filetype == 'cpp' || &filetype == 'c'
		silent! exe 'silent! vimgrepadd' '/\<'.a:word.'(\(\w\|,\|\s\|\r\|\n\)\{-})\(\s\|\r\|\n\)\{-}{/' '**/*.cpp' '**/*.cc' '**/*.h'
	elseif &filetype == 'python'
		silent! exe 'silent! vimgrepadd' '/\<def '.a:word.'(/' '**/*.py'
	elseif &filetype == 'go'
		silent! exe 'silent! vimgrepadd' '/\<func '.a:word.'(/' '**/*.go'
	else
		echo 'unsupport filetype: '.&filetype
		return
	endif
	call ShowQuickfixListIfNotEmpty()
endfunction

nnoremap <silent> <leader>fd :call VimGrepFindDefinition(expand("<cword>"))<CR>
vnoremap <silent> <leader>fd :call VimGrepFindDefinition(GetVisualSelection())<CR>
command! -nargs=1 Vimfd call VimGrepFindDefinition(<q-args>)

" Reference: vim.fandom.com/wiki/Searching_for_files
" find files and populate the quickfix list
" :find :new :edit :open 只能找一个文件，需要配合wildmenu逐级搜索文件夹
" :new 开新的window
" :edit 在当前buffer
" :open 无法使用通配符，不能使用wildmode
" :next 可以打开多个文件
function FindFiles(filename)
	cexpr system('find . -name "*'.a:filename.'*" | xargs file | sed "s/:/:1:/"')
	set errorformat=%f:%l:%m
	call ShowQuickfixListIfNotEmpty()
endfunction
command! -nargs=1 Find call FindFiles(<q-args>)

function Ripgrep(args)
	cexpr system('rg --vimgrep ' . a:args)
	call ShowQuickfixListIfNotEmpty()
endfunction
" fzf.vim defines :Rg
command! -nargs=1 Myrg call Ripgrep(<q-args>)

"""""""""""""""""""""""""""""""""""""" quickfix window

nnoremap <silent> co :copen<CR>
nnoremap <silent> cn :cn<CR>
nnoremap <silent> cp :cp<CR>
nnoremap <silent> ccl :ccl<CR>

vnoremap <silent> <leader>t :term ++open ++rows=9<CR>
nnoremap <silent> <leader>t :term ++rows=9<CR>
if exists(':tnoremap')
	tnoremap <silent> <leader>t <C-W>:hide<CR>
endif

function CExprSystem(args)
	cexpr system(a:args)
	call ShowQuickfixListIfNotEmpty()
endfunction
command! -nargs=1 CExprsys call CExprSystem(<q-args>)

""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Example:
" :e+22 ~/.vimrc
command! -nargs=0 VimExeLine exe getline(".")

" https://www.zhihu.com/question/30782510/answer/70078216
nnoremap zpr :setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2<CR>:set foldmethod=manual<CR><CR>
" 打开所有折叠: zR

set makeprg=make

command -nargs=0 Chat AsyncRun -mode=term -pos=curwin $HOME/vimrc.d/openai_app.py chat

function EchoGitBlame()
	let line_number = line(".")
	echo system('git blame -n -L ' . line_number . ',' . line_number . ' -- ' . expand('%'))
endfunction

" command -nargs=0 GitBlame !git blame -L line(".") + 1, line(".") + 1 -- %
command -range -nargs=0 GitBlame :!git blame -n -L <line1>,<line2> -- %

if &insertmode == 0
	" save
	inoremap <c-S> <esc>:w<CR>i
end

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                    TAGS                                      "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 递归向上层寻找tags文件
" set tags=tags;/

" Reference: https://cscope.sourceforge.net/cscope_maps.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CSCOPE settings for vim           
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:tags_use_cscope = 0
let s:tags_use_gtags = 0

" This tests to see if vim was configured with the '--enable-cscope' option
" when it was compiled.  If it wasn't, time to recompile vim... 
if has("cscope") && s:tags_use_cscope

	""""""""""""" Standard cscope/vim boilerplate

	" reset cscope:
	" :cs reset

	" use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
	set cscopetag

	" check cscope for definition of a symbol before checking ctags: set to 1
	" if you want the reverse search order.
	set csto=0

	" add any cscope database in current directory
	if filereadable("cscope.out")
		cs add cscope.out  
	" else add the database pointed to by environment variable 
	elseif $CSCOPE_DB != ""
		cs add $CSCOPE_DB
	endif

	" show msg when any other cscope db added
	set cscopeverbose

	""""""""""""" My cscope/vim key mappings
	"
	" The following maps all invoke one of the following cscope search types:
	"
	"   's'   symbol: find all references to the token under cursor
	"   'g'   global: find global definition(s) of the token under cursor
	"   'c'   calls:  find all calls to the function name under cursor
	"   't'   text:   find all instances of the text under cursor
	"   'e'   egrep:  egrep search for the word under cursor
	"   'f'   file:   open the filename under cursor
	"   'i'   includes: find files that include the filename under cursor
	"   'd'   called: find functions that function under cursor calls

	" nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
	" nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>
	" nmap <C-@><C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>

	if s:tags_use_gtags && s:has_vimrcd
		" use gtags-cscope
		set csprg=gtags-cscope
		source ~/vimrc.d/gtags-cscope.vim " https://www.gnu.org/software/global/globaldoc_toc.html#Gtags_002dcscope
	endif
elseif s:tags_use_gtags && s:has_vimrcd
	source ~/vimrc.d/gtags.vim " https://www.gnu.org/software/global/globaldoc_toc.html#Vim-editor
	nnoremap <C-]> :Gtags -d <C-R>=expand("<cword>")<CR><CR>
endif

" neovim 会报错
if isdirectory(expand('~/.vim/doc')) && !has('nvim')
	set helplang=cn
	helptags ~/.vim/doc
endif

" Load plugins
if s:has_vimrcd
	source ~/vimrc.d/plugin.vim
endif

function UpdateCocExtensions(ext)
	if exists('g:coc_global_extensions')
		let g:coc_global_extensions = g:coc_initial_global_extensions + [a:ext]
	endif
endfunction

if !exists("g:plugs") || !has_key(g:plugs, 'coc.nvim')
	" https://zhuanlan.zhihu.com/p/106309525
	if has("autocmd") && exists("+omnifunc")
		autocmd Filetype * if &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif
	endif
endif

" 设置状态行-----------------------------------
" 设置状态行显示常用信息
" %F 完整文件路径名
" %m 当前缓冲被修改标记
" %m 当前缓冲只读标记
" %h 帮助缓冲标记
" %w 预览缓冲标记
" %Y 文件类型
" %b ASCII值
" %B 十六进制值
" %l 行数
" %v 列数
" %p 当前行数占总行数的的百分比
" %L 总行数
" %{...} 评估表达式的值，并用值代替
" %{"[fenc=".(&fenc==""?&enc:&fenc).((exists("+bomb") && &bomb)?"+":"")."]"} 显示文件编码
" %{&ff} 显示文件类型
" 链接：https://zhuanlan.zhihu.com/p/532430825
set laststatus=2
if !has('nvim') || g:nvim_compatibility_with_vim == 1
	set statusline=%1*%F%m%r%h%w\ 
	let git_branch = system("git rev-parse --abbrev-ref HEAD 2> /dev/null")
	exe "set statusline +=" . git_branch
	if exists("g:plugs") && has_key(g:plugs, 'coc.nvim')
		function CocStatusLine()
			return exists(':CocInfo') ? "\ \|\ %{coc#status()}%{get(b:,'coc_current_function','')}" : ""
		endfunction
		set statusline+=%{%CocStatusLine()%}
	endif
	" 左对齐和右对齐的分割点
	set statusline+=%=\ 
	set statusline+=%2*\ %Y\ %3*%{\"\".(\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\"+\":\"\").\"\"}\ %4*[%l,%v]\ %5*%p%%\ \|\ %6*%LL\ 
endif

