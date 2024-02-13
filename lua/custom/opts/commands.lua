local wilder = require 'wilder'

local _M = {}

function _M.setup()
  vim.api.nvim_create_user_command(
    'GitCommit',
    '!git commit --signoff -m "$(gitmojify -m ' .. vim.fn.shellescape '<args>' .. ' || echo ' .. vim.fn.shellescape '<args>' .. ')"',
    { nargs = '*' }
  )
  vim.api.nvim_create_user_command('PreCommit', '!pre-commit run -a', { nargs = '*' })
  wilder.setup { modes = { ':', '/', '?' } }
end

return _M
