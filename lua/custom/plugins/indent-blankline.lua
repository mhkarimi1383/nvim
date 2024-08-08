return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  event = 'UIEnter',
  opts = {
    exclude = {
      -- stylua: ignore
      filetypes = {
        'dbout', 'neo-tree-popup', 'log', 'gitcommit',
        'txt', 'help', 'NvimTree', 'git', 'flutterToolsOutline',
        'undotree', 'markdown', 'norg', 'org', 'orgagenda',
      },
    },
    indent = {
      char = '│', -- ▏┆ ┊ 
      tab_char = '│',
    },
    scope = {
      char = '▎',
      -- highlight = {
      --   'RainbowDelimiterRed',
      --   'RainbowDelimiterYellow',
      --   'RainbowDelimiterBlue',
      --   'RainbowDelimiterOrange',
      --   'RainbowDelimiterGreen',
      --   'RainbowDelimiterViolet',
      --   'RainbowDelimiterCyan',
      -- },
    },
  },
  config = function(_, opts)
    require('ibl').setup(opts)
    local hooks = require 'ibl.hooks'
    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
  end,
}
