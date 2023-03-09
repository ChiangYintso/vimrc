set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

if exists("g:vscode")
	source ~/vimrc.d/basic.vim
	let g:loaded_netrw = 1
	let g:loaded_netrwPlugin = 1
else
	source ~/.vimrc
end