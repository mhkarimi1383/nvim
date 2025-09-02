local _M = {}

function _M.setup()
  require("neo-tree").setup({
    filesystem = {
      filtered_items = {
        visible = true,
      },
    },
    source_selector = {
      winbar = true,
      statusline = true,
      truncation_character = '…',
    },
  })
end

return _M
