lua << EOF
	local cmp = require'cmp'

	require('nvim-autopairs').setup{}
	local cmp_autopairs = require('nvim-autopairs.completion.cmp')
	cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))

	cmp.setup({
		snippet = {
			expand = function(args)
			  -- For `vsnip` user.
			  -- vim.fn["vsnip#anonymous"](args.body)

			  -- For `luasnip` user.
			  -- require('luasnip').lsp_expand(args.body)

			  -- For `ultisnips` user.
				vim.fn["UltiSnips#Anon"](args.body)
			end,
		},
		mapping = {
			['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
			['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
			['<C-d>'] = cmp.mapping.scroll_docs(-4),
			['<C-f>'] = cmp.mapping.scroll_docs(4),
			['<A-Space>'] = cmp.mapping.complete(),
			['<C-e>'] = cmp.mapping.close(),
			['<CR>'] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Replace,
				select = true,
			})
		},
		sources = {
			{ name = 'nvim_lsp' },

			-- For vsnip user.
			-- { name = 'vsnip' },

			-- For luasnip user.
			-- { name = 'luasnip' },

			-- For ultisnips user.
			{ name = 'ultisnips' },
			{ name = 'buffer' },
			{ name = "crates" },
		}
	})

	local lsp_installer = require("nvim-lsp-installer")
	local lsp_installer_servers = require'nvim-lsp-installer.servers'

	lsp_installer.settings({
		ui = {
			icons = {
				server_installed = "✓",
				server_pending = "➜",
				server_uninstalled = "✗"
			}
		}
	})

	local languages_installer = {"pylsp"}

	for _, language in ipairs(languages_installer) do
		local server_available, requested_server = lsp_installer_servers.get_server(language)
		if server_available then
			requested_server:on_ready(function ()
				local opts = {}
				requested_server:setup(opts)
			end)
			if not requested_server:is_installed() then
				-- Queue the server to be installed
				requested_server:install()
			end
		end
	end

	local lsp_installer_path = vim.fn.stdpath("data") .. "\\lsp_servers\\"

	require'lspconfig'.pylsp.setup{}

	require('rust-tools').setup({})
	require('rust-tools.inlay_hints').set_inlay_hints()
EOF
