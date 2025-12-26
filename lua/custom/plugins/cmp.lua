return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		{
			'gbprod/yanky.nvim',
			opts = {
				ring = { storage = "shada" },
			}
		},
		'windwp/nvim-autopairs',
		'onsails/lspkind.nvim',
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-buffer',
		'hrsh7th/cmp-path',
		'hrsh7th/cmp-cmdline',
		'crazyhulk/cmp-sign',
		'hrsh7th/cmp-nvim-lsp-document-symbol',
		'hrsh7th/cmp-nvim-lsp-signature-help',
		'petertriho/cmp-git',
		'Dynge/gitmoji.nvim',
		'dmitmel/cmp-cmdline-history',
		'teramako/cmp-cmdline-prompt.nvim',
		'tzachar/fuzzy.nvim',
		'tzachar/cmp-fuzzy-buffer',
		'tzachar/cmp-fuzzy-path',
		'chrisgrieser/cmp-nerdfont',
		'hrsh7th/cmp-emoji',
		'Snikimonkd/cmp-go-pkgs',
		'vrslev/cmp-pypi',
		'ray-x/cmp-treesitter',
		'ray-x/cmp-sql',
		'SergioRibera/cmp-dotenv'
	},
}
