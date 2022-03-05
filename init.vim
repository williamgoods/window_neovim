set number
set tabstop=4
set softtabstop=4
set shiftwidth =4
set noexpandtab
set autoindent
set ignorecase
set mouse=a

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

		use {"akinsho/toggleterm.nvim"}
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


	require("toggleterm").setup{
		open_mapping = [[<A-i>]],
		shell = 'nu'
	}
EOF

let mapleader=" "
nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>s :wa<cr>
nnoremap Q :qa<cr>
nnoremap <A-j> :bp<cr>
nnoremap <A-k> :bn<cr>

nnoremap j jzz
nnoremap k kzz

vnoremap < <gv
vnoremap > >gv

tnoremap <esc> <C-\><C-N>
