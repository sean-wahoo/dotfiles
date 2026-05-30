local MiniPlugins = {
	_plugins = {},
	get_plugin = function(self, name)
		if not self._plugins[name] then
			return
		end
		return self._plugins[name]
	end,
	set_plugin = function(self, name, plugin)
		self._plugins[name] = plugin
	end,
}

local ai_ok, ai = pcall(require, "mini.ai")
if not ai_ok then
	print("ai oop")
	return
end
MiniPlugins:set_plugin("mini.ai", ai)
local gen_spec = ai.gen_spec

local hi_ok, hi = pcall(require, "mini.hipatterns")
if not hi_ok then
	print("hipatterns oop")
	return
end
MiniPlugins:set_plugin("mini.hipatterns", hi)

require("ts_context_commentstring").setup({
	enable_autocmd = false,
})

local function shorthand_hex_color(buf_id, match, data)
	local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
	-- Expand #RGB to #RRGGBB
	local hex = string.format("#%s%s%s%s%s%s", r, r, g, g, b, b)

	-- Automatically compute whether white or black text is easier to read over the background
	local r_num, g_num, b_num = tonumber(r .. r, 16), tonumber(g .. g, 16), tonumber(b .. b, 16)
	local luma = (0.299 * r_num + 0.587 * g_num + 0.114 * b_num) / 255
	local fg = luma > 0.5 and "#000000" or "#FFFFFF"

	return hi.compute_hex_color_group(hex, "bg", { fg = fg })
end
local mini_plugins = {
	-- fuzzy = {},
	ai = {
		search_method = "cover_or_nearest",
	},
	pairs = {},
	-- tabline = {},
	-- git = {},
	icons = {},
	keymap = {},
	splitjoin = {},
	snippets = {},
	animate = {
		cursor = {
			enable = false,
		},
		scroll = { enable = true },
		resize = { enable = true },
		open = { enable = true },
		close = { enable = false },
	},
	hipatterns = {
		highlighters = {
			hex_color = hi.gen_highlighter.hex_color(),
			shorthand_hex = {
				pattern = "#%x%x%x%f[%X]",
				group = shorthand_hex_color,
			},
			-- tailwind = {
			--   pattern = "%f[%w_~-]text-[a-z]+-%d%d%d?%f[%W]",
			--   group = function (_, match)
			--     local color, weight = match:match("text-([a-z]+)-(%d+)")
			--     if color and weight then
			--       local clients = vim.lsp.get_clients({ name = "tailwindcss" })
			--     end
			--   end
			-- }
		},
	},
	comment = {
		options = {
			custom_commentstring = function()
				return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
			end,
		},
		mappings = {
			comment_line = "<leader>/",
			comment_visual = "<leader>/",
		},
	},
	-- starter = {},
	basics = {},
	extra = {},
	jump = {},
	cmdline = {},
	sessions = {
		autoread = true,
		autowrite = true,
	},
	bracketed = {},
	-- bufremove = {},
	indentscope = {},
	-- notify = {
	-- 	window = {
	-- 		max_width_share = 0.382,
	-- 	},
	-- 	lsp_progress = {
	-- 		enable = false,
	-- 	},
	-- },
}

MiniPlugins:set_plugin("mini.ai", ai)

local get_option = vim.filetype.get_option
vim.filetype.get_option = function(filetype, option)
	local ret_func = get_option
	if option == "commentstring" then
		ret_func = require("ts_context_commentstring.internal").calculate_commentstring
	end

	return ret_func(filetype, option)
end

for k, v in pairs(mini_plugins) do
	local p = MiniPlugins:get_plugin(k)
	if not p then
		local ok = false
		ok, p = pcall(require, "mini." .. k)
		if not ok then
			print("mini" .. k .. " failed to load")
			errors[k] = true
			goto continue
		else
			MiniPlugins:set_plugin(k, p)
		end
	end
	p.setup(v)

	::continue::
end
