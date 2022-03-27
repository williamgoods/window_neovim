set tabstop=4
set softtabstop=4
set shiftwidth =4
set noexpandtab
set autoindent
set ignorecase
set mouse=a

set clipboard+=unnamedplus
set termguicolors

lua << EOF
	local fn = vim.fn
	local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
	if fn.empty(fn.glob(install_path)) > 0 then
		packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
	end

	return require('packer').startup(function(use)
		local use = use

		use 'nvim-treesitter/nvim-treesitter'

		use {
			'Shatur/neovim-session-manager',
			requires = { {'nvim-lua/plenary.nvim'} }
		}
		use {
			'nvim-telescope/telescope.nvim',
			requires = { {'nvim-lua/plenary.nvim'} }
		}

		-- use {'akinsho/toggleterm.nvim'}

		use {'windwp/nvim-autopairs'}

		use {'mhartington/oceanic-next'}

		use {'xiyaowong/nvim-transparent'}

		-- Automatically set up your configuration after cloning packer.nvim
		-- Put this at the end after all plugins
		if packer_bootstrap then
			require('packer').sync()
		end
	end)
EOF

lua << EOF
	local configs = require'nvim-treesitter.configs'
	configs.setup {
	  ensure_installed = "maintained",
	  highlight = {
		enable = true,
	  }
	}

	local Path = require('plenary.path')
	require('session_manager').setup({
		sessions_dir = Path:new(vim.fn.stdpath('data'), 'sessions'), -- The directory where the session files will be saved.
		path_replacer = '__', -- The character to which the path separator will be replaced for session files.
		colon_replacer = '++', -- The character to which the colon symbol will be replaced for session files.
		-- autoload_mode = require('session_manager.config').AutoloadMode.LastSession, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
		autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
		autosave_last_session = true, -- Automatically save last session on exit and on session switch.
		autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
		autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
		'gitcommit',
		}, 
		autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
	})

	-- require("toggleterm").setup{
	-- 	open_mapping = [[<A-i>]],
	-- 	shell = 'nu',
	-- 	direction = 'horizontal'
	-- }

	require('nvim-autopairs').setup{}

	require("transparent").setup({
	  enable = true, -- boolean: enable transparent
	  extra_groups = { -- table/string: additional groups that should be clear
		-- In particular, when you set it to 'all', that means all avaliable groups

		-- example of akinsho/nvim-bufferline.lua
		"BufferLineTabClose",
		"BufferlineBufferSelected",
		"BufferLineFill",
		"BufferLineBackground",
		"BufferLineSeparator",
		"BufferLineIndicatorSelected",
	  },
	  exclude = {}, -- table: groups you don't want to clear
	})
EOF

" set laststatus=0

let mapleader=" "
nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>s :wa<cr>
nnoremap Q :qa<cr>
nnoremap <A-j> :bp<cr>
nnoremap <A-k> :bn<cr>

nnoremap <A-o> <C-o>

imap <A-e> <Esc>$a

nnoremap j jzz
nnoremap k kzz

vnoremap < <gv
vnoremap > >gv

tnoremap <esc> <C-\><C-N>

autocmd TermOpen * setlocal scrollback=-1

 syntax enable
" for vim 7
 set t_Co=256

" for vim 8
if (has("termguicolors"))
	set termguicolors
endif

colorscheme OceanicNext

let g:count = 0
let g:term_id = -1

func Exec(command)
	redir => output
	silent exec a:command
    	redir END
	return output
endfunc

function! IsTerm()
	let str = Exec("ls")
	let buflist = split(str, "\n")

	for item in buflist
		let idx = stridx(item, "term")
			
		if idx != -1
			let bufid = str2nr(item[0:3])
			echom "termid: " .. bufid

			if bufid == bufnr('%')
				echom "is a term"
				return 1	
			endif
		endif
	endfor

	return 0
endfunction

function! Toggleterm()
	let isterm = IsTerm()	

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



