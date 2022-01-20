local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	return
end

local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = {
	[[                               __                ]],
	[[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
	[[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
	[[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
	[[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
	[[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
	[[                                        for sean ]],
}
dashboard.section.buttons.val = {
	dashboard.button("f", "   Find File", ":Telescope find_files <CR>"),
	dashboard.button("e", "   New File", ":ene <BAR> startinsert <CR>"),
	dashboard.button("p", "   Find Project", ":Telescope projects <CR>"),
	dashboard.button("r", "   Recently Used Files", ":Telescope oldfiles <CR>"),
	dashboard.button("t", "   Find Text", ":Telescope live_grep <CR>"),
	dashboard.button("c", "   Configuration", ":e ~/.config/nvim/init.lua <CR>"),
	dashboard.button("q", "   Quit Neovim", ":qa<CR>"),
}

local function footer()
	return "gay ass"
end

dashboard.section.footer.val = footer()
dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"
dashboard.opts.opts.noautocmd = true

alpha.setup(dashboard.opts)
