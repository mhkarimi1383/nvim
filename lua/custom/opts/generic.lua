local _M = {}

function _M.setup()
  vim.o.hlsearch = false
  vim.wo.number = true
  vim.o.relativenumber = true
  vim.o.mouse = 'a'
  vim.o.clipboard = 'unnamedplus'
  vim.o.breakindent = true
  vim.o.undofile = true
  vim.o.ignorecase = true
  vim.o.smartcase = true
  vim.wo.signcolumn = 'yes'
  vim.o.updatetime = 250
  vim.o.timeoutlen = 300
  vim.o.completeopt = 'menuone,noselect'
  vim.o.termguicolors = true
  vim.o.guicursor =
  'n-v-c-sm:block,i-ci-ve:hor20,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175'
  vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
  vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
  vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
  vim.keymap.set('n', '<leader>db', function()
    require('dropbar.api').pick()
  end, { desc = 'Dropbar: pick from breadcrumb' })
  require("origami").setup {
    keepFoldsAcrossSessions = package.loaded["ufo"] ~= nil,
    pauseFoldsOnSearch = true,
    foldtextWithLineCount = {
      enabled = package.loaded["ufo"] == nil,
      template = "   %s lines", -- `%s` gets the number of folded lines
      hlgroupForCount = "Comment",
    },
    foldKeymaps = {
      setup = true, -- modifies `h` and `l`
      hOnlyOpensOnFirstColumn = false,
    },
    autoFold = {
      enabled = false,
      kinds = { "comment", "imports" }, ---@type lsp.FoldingRangeKind[]
    },
  }
end

return _M
