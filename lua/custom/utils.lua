local _M = {}

function _M.nmap(keys, func, desc, bufnr)
  if desc then
    desc = 'LSP: ' .. desc
  end

  vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
end

return _M
