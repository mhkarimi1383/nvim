return {
	"saghen/blink.cmp",
	dependencies = { 'rafamadriz/friendly-snippets' },
	-- build = 'nix run .#build-plugin',
	version = "1.*",
	opts = {
		completion = {
			documentation = { auto_show = true },
			trigger = {
				show_on_backspace = true,
				show_on_backspace_in_keyword = true,
				show_on_insert = true
			}
		},
		fuzzy = { implementation = "prefer_rust" },
		sources = {
			-- add lazydev to your completion providers
			default = { "lazydev", "lsp", "path", "snippets", "buffer" },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					-- make lazydev completions top priority (see `:h blink.cmp`)
					score_offset = 100,
				},
			},
		},
	},
	opts_extend = { "sources.default" }
}
