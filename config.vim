let g:neovimconfig = "~/AppData/Local/nvim/"
let g:config_files = ["lspconfig.vim", "misc.vim", "term.vim"]

set tabstop=4
set softtabstop=4
set shiftwidth =4
set noexpandtab
set autoindent
set ignorecase
set mouse=a
set relativenumber

set clipboard+=unnamedplus

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

		use {'windwp/nvim-autopairs'}

		use {'xiyaowong/nvim-transparent'}

		use {
			'neovim/nvim-lspconfig',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			'hrsh7th/nvim-cmp'
		}

		use 'simrat39/rust-tools.nvim'

		use {
			'SirVer/ultisnips',
			'quangnguyen30192/cmp-nvim-ultisnips'		
		}

		use {
			'williamboman/nvim-lsp-installer',
		}

		use 'projekt0n/github-nvim-theme'

		-- Automatically set up your configuration after cloning packer.nvim
		-- Put this at the end after all plugins
		if packer_bootstrap then
			require('packer').sync()
		end
	end)
EOF

let mapleader=" "

nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>

nnoremap <leader>s :wa<cr>
nnoremap Q :qa<cr>

function! BufferPrevious()
	execute "bp"

	if &buftype ==# 'terminal'
		call BufferPrevious()
	endif
endfunction

function! BufferNext()
	execute "bn"

	if &buftype ==# 'terminal'
		call BufferNext()
	endif
endfunction

nnoremap <silent><A-j> :call BufferPrevious()<cr>
nnoremap <silent><A-k> :call BufferNext()<cr>

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

set termguicolors

colorscheme github_light

for config_file in g:config_files
	execute 'source ' .. g:neovimconfig .. '/' .. config_file
endfor


