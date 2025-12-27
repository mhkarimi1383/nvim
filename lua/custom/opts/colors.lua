local lualine = require 'lualine'
local treesitter_configs = require 'nvim-treesitter.configs'
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
    float = {
      transparent = true,
      solid = true,
    },
    transparent_background = true, -- disables setting the background color.
    show_end_of_buffer = false,    -- shows the '~' characters after the end of buffers
    term_colors = false,           -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
      enabled = false,             -- dims the background color of inactive window
      shade = 'dark',
      percentage = 0.15,           -- percentage of the shade to apply to the inactive window
    },
    no_italic = false,             -- Force no italic
    no_bold = false,               -- Force no bold
    no_underline = false,          -- Force no underline
    styles = {                     -- Handles the styles of general hi groups (see `:h highlight-args`):
      comments = { 'italic' },     -- Change the style of comments
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
    custom_highlights = function(colors)
      return {
        NeoTreeCursorLine = { bg = colors.surface1, fg = colors.none },
        NeoTreePreview = { bg = colors.surface1, fg = colors.none },
      }
    end,
    default_integrations = true,
    integrations = {
      barbar = true,
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
        scope_color = 'text',
        colored_indent_levels = true,
      },
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { "italic" },
          hints = { "italic" },
          warnings = { "italic" },
          information = { "italic" },
          ok = { "italic" },
        },
        underlines = {
          errors = { "underline" },
          hints = { "underline" },
          warnings = { "underline" },
          information = { "underline" },
          ok = { "underline" },
        },
        inlay_hints = {
          background = true,
        },
      },
      telescope = {
        enabled = true,
        -- style = "nvchad"
      },
      which_key = true,
      dropbar = {
        enabled = true,
        color_mode = true,
      },
      copilot_vim = true,
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
        "proto"
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
      highlight = {
        enable = true,
        language_tree = true,
        additional_vim_regex_highlighting = { "org" },
      },
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
  local hooks = require "ibl.hooks"
  local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
  }
  require("ibl").setup {
    scope = {
      enabled = true,
      highlight = highlight,
      include = { node_type = { ["*"] = { "*" } } },
    },
  }

  hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
end

return _M
