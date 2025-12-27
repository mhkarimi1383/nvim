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
  vim.wo.spell = true
  vim.opt.list = true
  vim.opt.listchars = {
      space = "⋅",
      eol = "↴",
      tab = "▎_",
      trail = "•",
      extends = "❯",
      precedes = "❮",
      nbsp = "",
  }
  vim.opt.fillchars = {
      fold = " ",
      foldsep = " ",
      foldopen = "",
      foldclose = "",
      diff = "╱",
  }
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
  require("netrw").setup({
    -- File icons to use when `use_devicons` is false or if
    -- no icon is found for the given file type.
    icons = {
      symlink = '',
      directory = '',
      file = '',
    },
    -- Uses mini.icon or nvim-web-devicons if true, otherwise use the file icon specified above
    use_devicons = true,
    mappings = {
      -- Function mappings receive an object describing the node under the cursor
      ['p'] = function(payload) print(vim.inspect(payload)) end,
      -- String mappings are executed as vim commands
      ['<Leader>p'] = ":echo 'hello world'<CR>",
    },
  })
  ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
  local progress = vim.defaulttable()
  vim.api.nvim_create_autocmd("LspProgress", {
    ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      local value = ev.data.params
          .value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
      if not client or type(value) ~= "table" then
        return
      end
      local p = progress[client.id]

      for i = 1, #p + 1 do
        if i == #p + 1 or p[i].token == ev.data.params.token then
          p[i] = {
            token = ev.data.params.token,
            msg = ("[%3d%%] %s%s"):format(
              value.kind == "end" and 100 or value.percentage or 100,
              value.title or "",
              value.message and (" **%s**"):format(value.message) or ""
            ),
            done = value.kind == "end",
          }
          break
        end
      end

      local msg = {} ---@type string[]
      progress[client.id] = vim.tbl_filter(function(v)
        return table.insert(msg, v.msg) or not v.done
      end, p)

      local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
      vim.notify(table.concat(msg, "\n"), "info", {
        id = "lsp_progress",
        title = client.name,
        opts = function(notif)
          notif.icon = #progress[client.id] == 0 and " "
              or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
        end,
      })
    end,
  })
end

return _M
