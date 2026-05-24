local snacks_ok, snacks = pcall(require, "snacks")
if not snacks_ok then
	print("snacks oopsie!")
end

local keymap = require("user.keymaps").keymap
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

local M = {
	---@type fun(opts: snacks.terminal.Config)
	handle_opts = function(opts)
		for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
			opts[pos] = opts[pos] or {}
			table.insert(opts[pos], {
				ft = "snacks_terminal",
				size = { height = 0.4 },
				title = "%{b:snacks_terminal_id}: %{b:term_title}",
				pinned = true,
				filter = function(buf, win)
					return vim.w[win].snacks_win
						and vim.w[win].snacks_win.position == pos
						and vim.w[win].snacks_win.relative == "editor"
						and not vim.w[win].trouble_preview
				end,
			})
		end
		vim.tbl_deep_extend("force", opts, snacks_config)
	end,
}

keymap(modes, "<leader>tn", function()
	Snacks.terminal.open()
end, "new terminal")

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

return M
