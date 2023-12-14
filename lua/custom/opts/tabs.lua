local _M = {}

function _M.setup_maps()
  vim.keymap.set('n', '<', '<Cmd>BufferPrevious<CR>', { desc = 'Go to previous tab' })
  vim.keymap.set('n', '>', '<Cmd>BufferNext<CR>', { desc = 'Go to next tab' })
  vim.keymap.set('n', 'q', '<Cmd>BufferClose<CR>', { desc = 'Go to next tab' })
end

return _M
