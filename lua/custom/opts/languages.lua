local cmp = require 'cmp'
local mason = require 'mason'
local mason_lspconfig = require 'mason-lspconfig'
local lspkind = require('lspkind')

local _M = {}

local servers = {
  -- nginx_language_server = {},
  earthlyls = {},
  pylsp = {},
  vue_ls = {},
  terraformls = {},
  terraform_lsp = {},
  ts_ls = {
    filetypes = { "typescript", "typescriptreact", "typescript.tsx", "vue" },
    init_options = {
      name = "@vue/typescript-plugin",
      location = "/home/karimi/.npm-packages/lib/node_modules/@vue/typescript-plugin",
      languages = { "javascript", "typescript", "vue" },
    },
  },
  -- java_language_server = {
  --   version = "master"
  -- },
  jdtls = {},
  jinja_lsp = {},
  pyre = {},
  helm_ls = {},
  bashls = {},
  ansiblels = {},
  dockerls = {},
  marksman = {},
  grammarly = {},
  phpactor = {},
  sqlls = {},
  gopls = {},
  pyright = {},
  ruff_lsp = {},
  nil_ls = {
    settings = {
      ['nil'] = {
        formatting = {
          command = { "nixfmt" },
        },
      },
    },
  },
  jsonls = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
  yamlls = {
    yaml = {
      schemaStore = {
        enable = false,
        url = '',
      },
      schemas = require('schemastore').yaml.schemas {
        extra = {
          url = 'https://github.com/helmwave/helmwave/releases/latest/download/schema.json',
          name = 'Helmwave',
          description = 'Helmwave configuration',
          fileMatch = 'helmwave.yml',
        },
      },
    },
  },
  protols = {},
  lua_ls = {
    Lua = {
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        },
      },
      workspace = { checkThirdParty = true },
      telemetry = { enable = false },
    },
  },
}

for k, _ in pairs(servers) do
  servers[k]['virtual_text'] = {
    errors = { 'italic' },
    hints = { 'italic' },
    warnings = { 'italic' },
    information = { 'italic' },
    ok = { 'italic' },
  }
  servers[k]['underlines'] = {
    errors = { 'underline' },
    hints = { 'underline' },
    warnings = { 'underline' },
    information = { 'underline' },
    ok = { 'underline' },
  }
  servers[k]['inlay_hints'] = {
    background = true,
  }
end
vim.diagnostic.config {
  virtual_text = {
    errors = { 'italic' },
    hints = { 'italic' },
    warnings = { 'italic' },
    information = { 'italic' },
    ok = { 'italic' },
  },
  underlines = {
    errors = { 'underline' },
    hints = { 'underline' },
    warnings = { 'underline' },
    information = { 'underline' },
    ok = { 'underline' },
  },
  inlay_hints = {
    background = true,
  },
}

local on_attach = function(client, bufnr)
  require('custom.opts.telescope').setup_lsp_maps(bufnr)
  local nmap = require('custom.utils').nmap
  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame', bufnr)
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', bufnr)

  vim.api.nvim_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation', bufnr)
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation', bufnr)

  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration', bufnr)
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder', bufnr)
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder', bufnr)
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders', bufnr)

  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })

  local function stringExistsInTable(str, tbl)
    for _, value in ipairs(tbl) do
      if value == str then
        return true
      end
    end
    return false
  end
  if client.name == "yamlls" then
    if stringExistsInTable(vim.api.nvim_buf_get_option(bufnr, "filetype"), { "helm", "smarty" }) then
      vim.schedule(function()
        vim.cmd("LspStop ++force yamlls")
      end)
    end
  end
end

require('which-key').add {
  {
    { '<leader>c',  group = '[C]ode' },
    { '<leader>c_', hidden = true },
    { '<leader>d',  group = '[D]ocument' },
    { '<leader>d_', hidden = true },
    { '<leader>g',  group = '[G]it' },
    { '<leader>g_', hidden = true },
    { '<leader>h',  group = 'More git' },
    { '<leader>h_', hidden = true },
    { '<leader>r',  group = '[R]ename' },
    { '<leader>r_', hidden = true },
    { '<leader>s',  group = '[S]earch' },
    { '<leader>s_', hidden = true },
    { '<leader>w',  group = '[W]orkspace' },
    { '<leader>w_', hidden = true },
  },
}

local cmp_select = { behavior = cmp.SelectBehavior.Select }

function _M.setup()
  require('which-key').setup({
    triggers_blacklist = {
      n = { "d", "y" }
    }
  })
  mason.setup()
  local to_install = {}
  for server_name in pairs(servers) do
    if server_name ~= "ruff_lsp" then
      table.insert(to_install, server_name)
    end
  end
  mason_lspconfig.setup {
    automatic_installation = true,
    ensure_installed = to_install,
  }

  for server_name, server_config in pairs(servers) do
    vim.lsp.config(server_name, {
      settings = server_config,
      on_attach = on_attach,
      capabilities = require('cmp_nvim_lsp').default_capabilities(),
      filetypes = (servers[server_name] or {}).filetypes,
    })
  end
  local kind_icons = {
    Text = "",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "󰇽",
    Variable = "󰂡",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "󰅲",
  }

  cmp.setup {
    formatting = {
      format = lspkind.cmp_format({
        mode = 'symbol_text', -- show only symbol annotations
        maxwidth = {
          -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          -- can also be a function to dynamically calculate max width such as
          -- menu = function() return math.floor(0.45 * vim.o.columns) end,
          menu = 50,              -- leading text (labelDetails)
          abbr = 50,              -- actual suggestion item
        },
        ellipsis_char = '...',    -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
        show_labelDetails = true, -- show labelDetails in menu. Disabled by default

        -- The function below will be called before any actual modifications from lspkind
        -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
        before = function(entry, vim_item)
          -- ...
          return vim_item
        end
      })

    },
    mapping = cmp.mapping.preset.insert({
      ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
      ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
      ['<C-y>'] = cmp.mapping.confirm({ select = true }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ["<C-Space>"] = cmp.mapping.complete(),
      ['<Tab>'] = cmp.mapping.select_next_item(cmp_select),
      ['<S-Tab>'] = cmp.mapping.select_prev_item(cmp_select),
    }),
    sources = {
      { name = 'nvim_lsp' },
      { name = 'path' },
      { name = 'cmp-sign' },
      { name = 'vsnip' },
      { name = 'nvim_lsp_document_symbol' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'go_deep' },
      { name = 'git' },
      { name = 'gitmoji' },
      { name = 'cmdline' },
      { name = 'cmp-cmdline-history' },
      { name = 'cmp-cmdline-prompt' },
      { name = 'fuzzy_buffer' },
      { name = 'fuzzy_path' },
      { name = 'rg' },
      { name = 'nerdfont' },
      { name = 'emoji' },
      { name = 'go packages' },
      { name = 'pypi' },
      { name = 'treesitter' },
      { name = 'sql' },
      { name = 'cmp_yanky' },
      { name = 'dotenv' }
    },
  }
  require('nvim-autopairs').setup {}
  -- If you want to automatically add `(` after selecting a function or method
  local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
  cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
  vim.filetype.add {
    extension = {
      jinja = 'jinja',
      jinja2 = 'jinja',
      j2 = 'jinja',
    },
  }
  vim.filetype.add({
    pattern = {
      [".*/host_vars/.*%.ya?ml"] = "yaml.ansible",
      [".*/group_vars/.*%.ya?ml"] = "yaml.ansible",
      [".*/group_vars/.*/.*%.ya?ml"] = "yaml.ansible",
      [".*/playbook.*%.ya?ml"] = "yaml.ansible",
      [".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
      [".*/roles/.*/tasks/.*%.ya?ml"] = "yaml.ansible",
      [".*/roles/.*/handlers/.*%.ya?ml"] = "yaml.ansible",
      [".*/roles/.*/vars/.*%.ya?ml"] = "yaml.ansible",
      [".*/tasks/.*%.ya?ml"] = "yaml.ansible",
    },
  })
end

return _M
