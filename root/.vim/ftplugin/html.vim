" quit when a filetype was already loaded
if exists("b:current_filetype")
  finish
endif

" https://www.zhihu.com/question/547708456/answer/2645630850
function HtmlPrettify()
	if &filetype != 'html'
		echo 'not a html file'
		return
	endif
	silent! exec "s/<[^.]*>/\r&\r/g"
	silent! exec "g/^$/d"
	exec "normal ggVG="
endfunction

let b:current_filetype = 1
