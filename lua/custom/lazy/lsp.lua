return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"stevearc/conform.nvim",
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
		"b0o/schemastore.nvim",
		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			config = true,
		},
		{
			"ray-x/lsp_signature.nvim",
			event = "InsertEnter",
			opts = {
				bind = true,
			},
		},
		{
			"Wansmer/symbol-usage.nvim",
			event = "BufReadPre",
		},
	},

	config = function()
		require("conform").setup({
			formatters_by_ft = {},
		})
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		require("fidget").setup({})
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"nginx_language_server",
				"earthlyls",
				"vue_ls",
				"terraformls",
				"jinja_lsp",
				"helm_ls",
				"bashls",
				"ansiblels",
				"dockerls",
				"phpactor",
				"sqls",
				"gopls",
				"jsonls",
				"yamlls",
				"protols",
				"lua_ls",
				"rust_analyzer",
				"gopls",
				"vtsls",
				"tailwindcss",
				"basedpyright",
				"ruff",
				"nil_ls",
			},
			handlers = {
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,
				zls = function()
					local lspconfig = require("lspconfig")
					lspconfig.zls.setup({
						root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
						settings = {
							zls = {
								enable_inlay_hints = true,
								enable_snippets = true,
								warn_style = true,
							},
						},
					})
					vim.g.zig_fmt_parse_errors = 0
					vim.g.zig_fmt_autosave = 0
				end,
				["basedpyright"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.basedpyright.setup({
						settings = {
							python = {
								pythonPath = ".venv/bin/python",
							},
							basedpyright = {
								analysis = {
									typeCheckingMode = "standard",
									autoSearchPaths = true,
									useLibraryCodeForTypes = true,
								},
							},
						},
					})
				end,
				["lua_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								runtime = {
									version = "LuaJIT",
								},
								diagnostics = {
									globals = { "vim" },
								},
								workspace = {
									library = vim.api.nvim_get_runtime_file("", true),
									checkThirdParty = false,
								},
								format = {
									enable = true,
									defaultConfig = {
										indent_style = "tab",
										indent_size = 1,
									},
								},
							},
						},
					})
				end,
				["tailwindcss"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.tailwindcss.setup({
						capabilities = capabilities,
						filetypes = {
							"html",
							"css",
							"scss",
							"javascript",
							"javascriptreact",
							"typescript",
							"typescriptreact",
							"vue",
							"svelte",
							"heex",
						},
					})
				end,
				["jsonls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.jsonls.setup({
						capabilities = capabilities,
						settings = {
							json = {
								schemas = require("schemastore").json.schemas(),
								validate = { enable = true },
							},
						},
					})
				end,
				["yamlls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.yamlls.setup({
						capabilities = capabilities,
						settings = {
							yaml = {
								schemaStore = {
									enable = false,
									url = "",
								},
								schemas = require("schemastore").yaml.schemas({
									extra = {
										url = "https://github.com/helmwave/helmwave/releases/latest/download/schema.json",
										name = "Helmwave",
										description = "Helmwave configuration",
										fileMatch = "helmwave.yml",
									},
								}),
							},
						},
					})
				end,
			},
		})

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = "lazydev", group_index = 0 },
				{ name = "copilot", group_index = 2 },
				{ name = "nvim_lsp" },
				{ name = "luasnip" }, -- For luasnip users.
			}, {
				{ name = "buffer" },
			}),
		})

		vim.diagnostic.config({
			-- update_in_insert = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})
		local rp = require("rose-pine.palette")
		local function set_symbol_usage_hl()
			vim.api.nvim_set_hl(0, "SymbolUsageContent", {
				fg = rp.subtle,
				bg = vim.api.nvim_get_hl(0, { name = "CursorLine", link = false }).bg,
			})
			vim.api.nvim_set_hl(0, "SymbolUsageRounding", {
				-- fg = rp.subtle,
				fg = vim.api.nvim_get_hl(0, { name = "CursorLine", link = false }).bg,
			})
			vim.api.nvim_set_hl(0, "SymbolUsageRef", {
				fg = rp.rose,
				bg = vim.api.nvim_get_hl(0, { name = "CursorLine", link = false }).bg,
				bold = true,
			})
			vim.api.nvim_set_hl(0, "SymbolUsageDef", {
				fg = rp.iris,
				bg = vim.api.nvim_get_hl(0, { name = "CursorLine", link = false }).bg,
				bold = true,
			})
			vim.api.nvim_set_hl(0, "SymbolUsageImpl", {
				fg = rp.foam,
				bg = vim.api.nvim_get_hl(0, { name = "CursorLine", link = false }).bg,
				bold = true,
			})
		end
		set_symbol_usage_hl()
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = set_symbol_usage_hl,
		})
		vim.schedule(set_symbol_usage_hl)
		local function text_format(symbol)
			local res = {}

			local round_start = { "", "SymbolUsageRounding" }
			local round_end = { "", "SymbolUsageRounding" }

			-- Indicator that shows if there are any other symbols in the same line
			local stacked_functions_content = symbol.stacked_count > 0 and ("+%s"):format(symbol.stacked_count) or ""

			if symbol.references then
				local usage = symbol.references <= 1 and "usage" or "usages"
				local num = symbol.references == 0 and "no" or symbol.references
				table.insert(res, round_start)
				table.insert(res, { "󰌹 ", "SymbolUsageRef" })
				table.insert(res, { ("%s %s"):format(num, usage), "SymbolUsageContent" })
				table.insert(res, round_end)
			end

			if symbol.definition then
				if #res > 0 then
					table.insert(res, { " ", "NonText" })
				end
				table.insert(res, round_start)
				table.insert(res, { "󰳽 ", "SymbolUsageDef" })
				table.insert(res, { symbol.definition .. " defs", "SymbolUsageContent" })
				table.insert(res, round_end)
			end

			if symbol.implementation then
				if #res > 0 then
					table.insert(res, { " ", "NonText" })
				end
				table.insert(res, round_start)
				table.insert(res, { "󰡱 ", "SymbolUsageImpl" })
				table.insert(res, { symbol.implementation .. " impls", "SymbolUsageContent" })
				table.insert(res, round_end)
			end

			if stacked_functions_content ~= "" then
				if #res > 0 then
					table.insert(res, { " ", "NonText" })
				end
				table.insert(res, round_start)
				table.insert(res, { " ", "SymbolUsageImpl" })
				table.insert(res, { stacked_functions_content, "SymbolUsageContent" })
				table.insert(res, round_end)
			end

			return res
		end
		local SymbolKind = vim.lsp.protocol.SymbolKind
		require("symbol-usage").setup({
			text_format = text_format,
			kinds = {
				SymbolKind.Function,
				SymbolKind.Method,
				SymbolKind.Class,
				SymbolKind.Struct,
				SymbolKind.Enum,
				SymbolKind.Constant,
				SymbolKind.Interface,
				SymbolKind.Module,
				SymbolKind.Property,
				SymbolKind.Field,
				SymbolKind.Constructor,
				SymbolKind.Event,
				SymbolKind.Operator,
				SymbolKind.TypeParameter,
			},
		})
		vim.filetype.add({
			extension = {
				jinja = "jinja",
				jinja2 = "jinja",
				j2 = "jinja",
			},
		})
		vim.filetype.add({
			pattern = {
				[".*/host_vars/.*%.ya?ml"] = "yaml.ansible",
				[".*/group_vars/.*%.ya?ml"] = "yaml.ansible",
				[".*/group_vars/.*/.*%.ya?ml"] = "yaml.ansible",
				[".*/playbook.*%.ya?ml"] = "yaml.ansible",
				[".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
				[".*/roles/.*/tasks/.*%.ya?ml"] = "yaml.ansible",
				[".*/roles/.*/handlers/.*%.ya?ml"] = "yaml.ansible",
				[".*/roles/.*/vars/.*%.ya?ml"] = "yaml.ansible",
				[".*/tasks/.*%.ya?ml"] = "yaml.ansible",
			},
		})
	end,
}
