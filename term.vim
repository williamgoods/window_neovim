
let g:count = 0
let g:term_id = -1

func Exec(command)
	redir => output
	silent exec a:command
    	redir END
	return output
endfunc

function! IsTerm(bufid)
	let str = Exec("ls")
	let buflist = split(str, "\n")

	for item in buflist
		let idx = stridx(item, "term")
			
		if idx != -1
			let bufid = str2nr(item[0:3])
			" echom "termid: " .. bufid

			if bufid == a:bufid
				echom "is a term"
				return 1	
			endif
		endif
	endfor

	return 0
endfunction

function! TermHook()
	let g:count = 0
	let g:term_id = -1
	execute "q"
endfunction

autocmd TermClose * call TermHook()

function! Toggleterm()
	let isterm = IsTerm(bufnr('%'))	

	if isterm
		call feedkeys("\<C-W>")
		call Hideterm()
	elseif g:count == 0
		execute "split"
		execute "ter nu"	
		let g:count = 1
		let g:term_id = bufnr('%')
	else 
		" 如果有终端打开过就将终端重新打开
		execute "split"
		execute "buffer " .. g:term_id
	endif	
endfunction

function! Hideterm()
	if g:count == 1
		execute "hide"
	endif	
endfunction

function! Killterm()
	if g:count == 1
		execute "bdelete! " .. g:term_id
		let g:count = 0
		let g:term_id = -1
	endif
endfunction

function! CloseTerm()
	if g:term_id != -1 
		execute "bdelete! " .. g:term_id
	endif 

	execute "qa"
endfunction

tnoremap <Esc> <C-\><C-n>

nnoremap <A-i> :call Toggleterm()<CR> 
tmap <A-i> <esc>:call Hideterm()<CR> 
tmap <A-k> <esc>:call Killterm()<CR> 

nnoremap <leader>qq :call CloseTerm()<cr>
nnoremap <leader>ss <cmd>:wa<cr>
