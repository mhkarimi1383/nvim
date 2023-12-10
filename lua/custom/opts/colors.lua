local _M = {}

function _M.setup()
	vim.cmd [[colorscheme dracula]]

	require('lualine').setup {
		options = {
			theme = "dracula-nvim",
		},
	}

	local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
	vim.api.nvim_create_autocmd('TextYankPost', {
		callback = function()
			vim.highlight.on_yank()
		end,
		group = highlight_group,
		pattern = '*',
	})
end

return _M
