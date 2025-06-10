vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.termguicolors = true

local lazy = require 'custom.lazy'
lazy.init()
lazy.setup()
require('custom.opts.colors').setup()
require('custom.opts.telescope').setup()
require('custom.opts.generic').setup()
require('custom.opts.languages').setup()
require('custom.opts.commands').setup()
require('custom.opts.tabs').setup_maps()

-- vim: ts=2 sts=2 sw=2 et
