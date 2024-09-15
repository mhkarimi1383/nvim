local _M = {}

function _M.init()
  local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      lazypath,
    }
  end
  vim.opt.rtp:prepend(lazypath)
end

function _M.setup()
  require("lazy").setup({
    spec = {
      { import = "custom.plugins" },
    },
    lockfile = vim.fn.stdpath("data") .. "lazy/lock.json",
  })
end

return _M
