return {
  'mvllow/modes.nvim',
  config = function()
    require('modes').setup({
      ignore = {
        '!neo-tree',
        '!neo-tree-popup',
        '!neo-tree-preview',
        '!NvimTree',
        '!TelescopePrompt',
      },
    })
  end
}
