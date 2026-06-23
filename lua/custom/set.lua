vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.o.clipboard = "unnamedplus"

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
	"n-v-c-sm:block,i-ci-ve:hor20,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"
