local lualine = require 'lualine'
local treesitter_configs = require 'nvim-treesitter.configs'
local rainbow_delimiters = require 'rainbow-delimiters'
local catppuccin = require 'catppuccin'
local sign = vim.fn.sign_define

local _M = {}

function _M.setup()
  catppuccin.setup {
    flavour = 'mocha', -- latte, frappe, macchiato, mocha
    background = {     -- :h background
      light = 'latte',
      dark = 'mocha',
    },
    transparent_background = false, -- disables setting the background color.
    show_end_of_buffer = false,     -- shows the '~' characters after the end of buffers
    term_colors = false,            -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
      enabled = false,              -- dims the background color of inactive window
      shade = 'dark',
      percentage = 0.15,            -- percentage of the shade to apply to the inactive window
    },
    no_italic = false,              -- Force no italic
    no_bold = false,                -- Force no bold
    no_underline = false,           -- Force no underline
    styles = {                      -- Handles the styles of general hi groups (see `:h highlight-args`):
      comments = { 'italic' },      -- Change the style of comments
      conditionals = { 'italic' },
      loops = { 'italic' },
      functions = { 'italic' },
      keywords = { 'italic' },
      strings = {},
      variables = {},
      numbers = {},
      booleans = { 'italic' },
      properties = {},
      types = { 'italic' },
      operators = {},
      -- miscs = {}, -- Uncomment to turn off hard-coded styles
    },
    color_overrides = {},
    custom_highlights = {},
    default_integrations = true,
    integrations = {
      gitsigns = true,
      nvimtree = true,
      dap = true,
      treesitter = true,
      notify = true,
      mason = true,
      fzf = true,
      neotree = true,
      cmp = true,
      dap_ui = true,
      rainbow_delimiters = true,
      mini = {
        enabled = true,
        indentscope_color = '',
      },
      indent_blankline = {
        enabled = true,
        scope_color = '', -- catppuccin color (eg. `lavender`) Default: text
        colored_indent_levels = true,
      },
      telescope = {
        enabled = true,
        -- style = "nvchad"
      },
      -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
  }
  lualine.setup {
    options = {
      theme = 'catppuccin',
      -- ... the rest of your lualine config
    },
  }
  sign('DapBreakpoint', { text = '●', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
  sign('DapBreakpointCondition', { text = '●', texthl = 'DapBreakpointCondition', linehl = '', numhl = '' })
  sign('DapLogPoint', { text = '◆', texthl = 'DapLogPoint', linehl = '', numhl = '' })
  vim.cmd 'colorscheme catppuccin'
  vim.o.background = 'dark'
  vim.g.rainbow_delimiters = {
    strategy = {
      [''] = rainbow_delimiters.strategy['global'],
      vim = rainbow_delimiters.strategy['local'],
    },
    query = {
      [''] = 'rainbow-delimiters',
      lua = 'rainbow-blocks',
    },
    highlight = {
      'RainbowDelimiterRed',
      'RainbowDelimiterYellow',
      'RainbowDelimiterBlue',
      'RainbowDelimiterOrange',
      'RainbowDelimiterGreen',
      'RainbowDelimiterViolet',
      'RainbowDelimiterCyan',
    },
  }
  local highlight = {
    'RainbowRed',
    'RainbowYellow',
    'RainbowBlue',
    'RainbowOrange',
    'RainbowGreen',
    'RainbowViolet',
    'RainbowCyan',
  }
  local hooks = require 'ibl.hooks'
  -- create the highlight groups in the highlight setup hook, so they are reset
  -- every time the colorscheme changes
  hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
    vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
    vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
    vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
    vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
    vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
    vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#56B6C2' })
  end)

  vim.g.rainbow_delimiters = { highlight = highlight }
  require('ibl').setup { scope = { highlight = highlight } }

  hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
  local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
      vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
  })

  vim.defer_fn(function()
    treesitter_configs.setup {
      ensure_installed = {
        'c',
        'markdown',
        'markdown_inline',
        'cpp',
        'go',
        'lua',
        'gomod',
        'gosum',
        'hurl',
        'json',
        'yaml',
        'gowork',
        'python',
        'rust',
        'tsx',
        'javascript',
        'typescript',
        'vimdoc',
        'vim',
        'bash',
        'nginx',
        'vue',
        'jinja',
        'jinja_inline',
        'helm',
        'dockerfile',
        'nix',
        'markdown',
        'markdown_inline',
        'php',
        'sql',
        'jsonc',
        'ini',
        'jq',
      },

      rainbow = {
        enable = true,
        disable = { 'jsx', 'cpp' },
        query = 'rainbow-parens',
        strategy = require('rainbow-delimiters').strategy.global,
      },
      sync_install = false,
      ignore_install = {},
      modules = {},
      auto_install = false,
      refactor = {
        navigation = {
          enable = true,
          keymaps = {
            goto_definition = 'gnd',
            list_definitions = 'gnD',
            list_definitions_toc = 'gO',
            goto_next_usage = '<a-*>',
            goto_previous_usage = '<a-#>',
          },
        },
      },
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<c-space>',
          node_incremental = '<c-space>',
          scope_incremental = '<c-s>',
          node_decremental = '<M-space>',
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>a'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>A'] = '@parameter.inner',
          },
        },
      },
    }
  end, 0)
end

return _M
