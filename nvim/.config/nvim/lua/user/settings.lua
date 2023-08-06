print('hah')
local options = {
	backup = false,
	clipboard = "unnamedplus",
	cmdheight = 1,
	completeopt = { "menuone", "noselect" },
	conceallevel = 0,
  signcolumn = "yes",
	fileencoding = "utf8",
	hlsearch = true,
	ignorecase = true,
	mouse = "a",
	pumheight = 10,
	showtabline = 0,
	smartcase = true,
  showmode = false,
	smartindent = true,
	splitbelow = true,
  syntax = "on",
	splitright = true,
	swapfile = false,
	termguicolors = true,
	timeoutlen = 100,
	undofile = true,
	updatetime = 100,
	writebackup = false,
	expandtab = true,
	shiftwidth = 2,
	tabstop = 2,
	cursorline = true,
	number = true,
	relativenumber = true,
	laststatus = 3,
	showcmd = false,
	ruler = false,
	numberwidth = 4,
	scrolloff = 12,
	sidescrolloff = 8,
	wrap = false,
	title = true,
  foldmethod = "expr",
  foldexpr = "nvim_treesitter#foldexpr()",
  foldcolumn = '1',
  foldlevel = 99,
  foldlevelstart = 99,
  foldenable = true
}

vim.opt.fillchars:append 'eob: ,fold: ,foldopen:,foldsep: ,foldclose:'

vim.opt.fillchars:append {
	stl = ' ',
}

vim.opt.shortmess:append "c"

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]

vim.filetype.add {
  extension = {
    conf = "dosini",
  },
}
