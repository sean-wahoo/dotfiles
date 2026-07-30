local keymap = require("user.keymaps").keymap
local snacks_ok, snacks = pcall(require, "snacks")
if not snacks_ok then
	print("snacks failed to load!")
	return
end

local modes = { "n", "t" }
local snacks_config = {
	notifier = {},
	input = {},
	notify = {},
	explorer = {
		config = {
			replace_netrw = true,
		},
	},
	quickfile = {},
	profiler = {},
	dashboard = {},
	statuscolumn = {},
	animate = {},
	win = {},
	words = {},
	---@type snacks.terminal.Config
	terminal = {
		auto_close = true,
		auto_insert = false,
		start_insert = false,
		on_buf = function(self)
			keymap(modes, "<leader>tf", function()
				self:hide()
			end, "toggle focus/hide")
			keymap(modes, "<leader>td", function()
				self:close()
			end, "destroy terminal")
		end,
		bo = {
			filetype = "snacks_terminal",
		},
	},
}

snacks.setup(snacks_config)
keymap(modes, "<leader>tn", function()
	snacks.terminal.open()
end, "new terminal")

snacks.toggle.profiler():map("<leader>pp")
snacks.toggle.profiler_highlights():map("<leader>ph")
keymap("n", "<leader>ps", function()
	snacks.profiler.scratch()
end, "scratch profiler")

local mini_keymap_ok, mini_keymap = pcall(require, "mini.keymap")
if not mini_keymap_ok then
	print("mini keymap oopsie!")
else
	local no_term_modes = { "i", "c", "x", "s" }
	mini_keymap.map_combo(no_term_modes, "jk", "<bs><bs><esc>")
	mini_keymap.map_combo(no_term_modes, "kj", "<bs><bs><esc>")
	mini_keymap.map_combo("t", "jk", "<bs><bs><esc><esc>")
	mini_keymap.map_combo("t", "kj", "<bs><bs><esc><esc>")
end
return snacks
