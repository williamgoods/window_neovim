
let g:count = 0
let g:term_id = -1
let g:term_win_id = -1

func Exec(command)
	redir => output
	silent exec a:command
    	redir END
	return output
endfunc

function CloseTabs(state) 
    let str = Exec("ls")
    let buflist = split(str, "\n")

    for item in buflist
        let idx = stridx(item, a:state)

        if idx != -1 
            let bufid = str2nr(item[0:3])
            silent exec "bdelete! " .. bufid    
            echo "delete buffer " .. bufid
        endif
    endfor
endfunction

function! IsTerm(bufid)
	let str = Exec("ls")
	let buflist = split(str, "\n")

	for item in buflist
		let idx = stridx(item, "term://")
			
		if idx != -1
			let bufid = str2nr(item[0:3])
			echom "termid: " .. bufid

			if bufid == a:bufid
				echom "is a term"
				return 1	
			endif
		endif
	endfor

	return 0
endfunction

" function! IsRunning(buf)
"     return getbufvar(a:buf, '&buftype') !=# 'terminal' ? 0 :
"         \ has('terminal') ? term_getstatus(a:buf) =~# 'running' :
"         \ has('nvim') ? jobwait([getbufvar(a:buf, '&channel')], 0)[0] == -1 :
"         \ 0
" endfunction

function! TermHook()
	let g:count = 0
	let g:term_id = -1
endfunction

autocmd TermClose * call TermHook()

function! Toggleterm()
	let isterm = IsTerm(bufnr('%'))	
	echom "isterm: " .. isterm

	if isterm
		call feedkeys("\<C-W>")
		call Hideterm()
	elseif g:count == 0
		execute "split"
		execute "ter nu"	
		let g:count = 1
		let g:term_id = bufnr('%')
		let g:term_win_id = win_getid()
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
		execute "bd! " .. g:term_id
		let g:count = 0
		let g:term_id = -1
		let g:term_win_id = -1
	endif
endfunction

function! CloseTerm()
	call Killterm()
	call CloseTabs("No Name")

	execute "LspStop"
	execute "qa"
endfunction

tnoremap <Esc> <C-\><C-n>

nnoremap <A-i> :call Toggleterm()<CR> 
tmap <A-i> <esc>:call Hideterm()<CR> 
tmap <A-k> <esc>:call Killterm()<CR> 

nnoremap <leader>qq :call CloseTerm()<cr>
nnoremap <leader>ss <cmd>:wa<cr>

augroup terminal_settings
autocmd!

function OnStart()
    call CloseTabs("No Name")
endfunction

autocmd VimEnter * nested call OnStart()
