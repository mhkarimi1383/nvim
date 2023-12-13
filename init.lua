vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazy = require("custom.lazy")
lazy.init()
lazy.setup()

require('neodev').setup()
require("custom.opts.colors").setup()
require("custom.opts.telescope").setup()
require("custom.opts.generic").setup()
require("custom.opts.languages").setup()
require("custom.opts.commands").setup()

-- vim: ts=2 sts=2 sw=2 et
