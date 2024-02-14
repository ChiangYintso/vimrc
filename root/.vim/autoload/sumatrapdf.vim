function sumatrapdf#SendToVim(args)
	"24 d:\hello\world.tex -> ['24', 'd', '\hello\world.tex']
	let l:arglist = split(a:args, '[: ]') 

	let l:line = l:arglist[0]
	let l:diskname = l:arglist[1]
	let l:diskname = tolower(l:diskname)

	" \hello\world.tex -> /mnt/d/hello/world.tex
	let l:wslpath = l:arglist[2]
	let l:wslpath = substitute(l:wslpath, '\', "/", "g")

	let l:newargs = join([l:line, ' /mnt/', l:diskname, l:wslpath], '')
	execute 'edit +' . l:newargs
endfunction
