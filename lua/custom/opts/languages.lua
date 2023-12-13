local mason = require("mason")
local mason_lspconfig = require('mason-lspconfig')
local cmp = require('cmp')
local luasnip = require('luasnip')

local _M = {}

local servers = {
	nginx_language_server = {},
	bashls = {},
	ansiblels = {},
	dockerls = {},
	marksman = {},
	grammarly = {},
	gopls = {},
	pyright = {},
	jsonls = {
		json = {
			schemas = require('schemastore').json.schemas(),
			validate = { enable = true },
		},
	},
	yamlls = {
		yaml = {
			schemaStore = {
				enable = false,
				url = "",
			},
			schemas = require('schemastore').yaml.schemas(),
		},
	},
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
}

local langservers = {}

-- Exclude languages that are not supported by mason
local excluded_langservers_from_installer = { nginx_language_server = true }

for key, _ in pairs(servers) do
	if (excluded_langservers_from_installer[key] or false) ~= true then
		table.insert(langservers, key)
	end
end


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local on_attach = function(_, bufnr)
	require("custom.opts.telescope").setup_lsp_maps(bufnr)
	local nmap = require("custom.utils").nmap
	nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame', bufnr)
	nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', bufnr)

	vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
	nmap('K', vim.lsp.buf.hover, 'Hover Documentation', bufnr)
	nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation', bufnr)

	nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration', bufnr)
	nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder', bufnr)
	nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder', bufnr)
	nmap('<leader>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, '[W]orkspace [L]ist Folders', bufnr)

	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
		vim.lsp.buf.format()
	end, { desc = 'Format current buffer with LSP' })
end

require('which-key').register {
	['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
	['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
	['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
	['<leader>h'] = { name = 'More git', _ = 'which_key_ignore' },
	['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
	['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
	['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
}

function _M.setup()
	mason.setup()
	mason_lspconfig.setup {
		ensure_installed = langservers,
	}

	mason_lspconfig.setup_handlers {
		function(server_name)
			require('lspconfig')[server_name].setup {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = servers[server_name],
				filetypes = (servers[server_name] or {}).filetypes,
			}
		end,
	}

	require('luasnip.loaders.from_vscode').lazy_load()
	luasnip.config.setup {}

	cmp.setup {
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		mapping = cmp.mapping.preset.insert {
			['<C-n>'] = cmp.mapping.select_next_item(),
			['<C-p>'] = cmp.mapping.select_prev_item(),
			['<C-d>'] = cmp.mapping.scroll_docs(-4),
			['<C-f>'] = cmp.mapping.scroll_docs(4),
			['<C-Space>'] = cmp.mapping.complete {},
			['<CR>'] = cmp.mapping.confirm {
				behavior = cmp.ConfirmBehavior.Replace,
				select = true,
			},
			['<Tab>'] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expand_or_locally_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end, { 'i', 's' }),
			['<S-Tab>'] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.locally_jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { 'i', 's' }),
		},
		sources = {
			{ name = 'nvim_lsp' },
		},
	}
end

return _M
