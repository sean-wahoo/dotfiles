vim.g.use_ai = false
---@class PluginItem
---@field name string
---@field enable function

local M = {
	---@type PluginItem[]
	plugins = {},
}

local plugin_list = { "codecompanion", "cursortab", "gp" }

---@param plugin_name? string
M.get_plugin = function(self, plugin_name)
	for _, plugin in next, self.plugins do
		if plugin_name == plugin.name then
			return plugin
		end
	end
end

M.get_plugins = function(self)
	return self.plugins
end

M.refresh = function(self)
	for _, plugin_name in next, plugin_list do
		local plugin_ok, plugin = pcall(require, "user." .. plugin_name)
		if not plugin_ok then
			print("plugin oopsie during refresh!")
			for index, self_plugin in next, self.plugins do
				if self_plugin.name == plugin_name then
					table.remove(self.plugins, index)
					package.loaded[plugin_name] = nil
					break
				end
			end
		else
			plugin:enable()
			local found = false
			for _, self_plugin in next, self.plugins do
				if self_plugin.name == plugin_name then
					found = true
				end
			end

			if not found then
				table.insert(self.plugins, plugin)
			end
		end
	end
end

M:refresh()

local keymap = require("user.keymaps").keymap

keymap("n", "<leader>ae", function()
	vim.g.use_ai = true
	M:refresh()
end, "enable ai")

keymap("n", "<leader>ad", function()
	vim.g.use_ai = false
	vim.notify("ai disabled! (requires neovim restart)")
	-- M:refresh()
end, "disable ai")

-- keymap('n', "<leader>acl", "<cmd>CodeCompanion<cr>")
keymap("v", "<leader>agl", function()
	local function get_visual_selection()
		local _, srow, scol = unpack(vim.fn.getpos("v"))
		local _, erow, ecol = unpack(vim.fn.getpos("."))
		if srow > erow then
			srow, erow = erow, srow
		end
		if scol > ecol then
			scol, ecol = ecol, scol
		end
		return vim.api.nvim_buf_get_text(0, srow - 1, scol - 1, erow - 1, ecol, {})[1]
	end
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)

	-- Now trigger CodeCompanion with the finalized range
	vim.schedule(function()
		vim.cmd("'<,'>CodeCompanion")
	end)
	local prompt = get_visual_selection()
	vim.cmd("'<,'>CodeCompanion " .. prompt)
end, "execute selection as prompt (codecompanion)")
keymap("v", "<leader>agr", function()
	local function get_visual_selection()
		local _, srow, scol = unpack(vim.fn.getpos("v"))
		local _, erow, ecol = unpack(vim.fn.getpos("."))
		if srow > erow then
			srow, erow = erow, srow
		end
		if scol > ecol then
			scol, ecol = ecol, scol
		end
		return vim.api.nvim_buf_get_text(0, srow - 1, scol - 1, erow - 1, ecol, {})[1]
	end
	-- This internal function triggers the rewrite using the selection as the prompt
	local prompt = get_visual_selection()
	vim.cmd("<C-u>'<,'>GpRewrite " .. prompt)
end, "execute selection as prompt (gp)")

return M
