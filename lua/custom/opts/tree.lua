local _M = {}

function _M.setup()
  require("neo-tree").setup({
    sources = {
      'filesystem',
      'buffers',
      'git_status',
      'document_symbols',
    },
    source_selector = {
      truncation_character = "…",
      winbar = true,
      statusline = true,
      show_scrolled_off_parent_node = true,
      sources = {
        { source = 'filesystem' },
        { source = 'buffers' },
        { source = 'git_status' },
        { source = 'document_symbols' },
      },
    },
    hijack_netrw_behavior = 'open_default',
    window = {
      position = "right",
    },
    enable_opened_markers = true,
    default_component_configs = {
      name = {
        highlight_opened_files = true,
      }
    },
    use_libuv_file_watcher = true,
    filesystem = {
      follow_current_file = {
        enabled = true
      },
      filtered_items = {
        visible = true,
      },
    },
  })
end

return _M
