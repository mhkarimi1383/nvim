return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
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
    },
  },
}
