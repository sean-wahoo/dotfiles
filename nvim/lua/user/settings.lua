local o = vim.opt

local options = {
	number = true,
	signcolumn = "yes",
	termguicolors = true,
	tabstop = 2,
	cindent = true,
	softtabstop = 2,
	shiftwidth = 2,
	autoindent = true,
	smartindent = true,
	scrolloff = 8,
	sidescrolloff = 8,
	backup = false,
	clipboard = "unnamedplus",
	completeopt = { "menuone", "noselect" },
	conceallevel = 0,
	hlsearch = true,
	ignorecase = true,
	mouse = "a",
	pumheight = 10,
	showmode = false,
	showtabline = 2,
	smartcase = true,
	splitbelow = true,
	splitright = true,
	swapfile = false,
	timeoutlen = 100,
	undofile = true,
	updatetime = 300,
	writebackup = false,
	expandtab = true,
	cursorline = true,
	numberwidth = 4,
	wrap = false,
}

vim.opt.cinoptions:append("0")
vim.opt.shortmess:append("c")

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[set iskeyword+=-]])
vim.cmd([[set formatoptions-=cro]])
