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

local mini_plugins = {
	-- fuzzy = {},
	ai = {
		custom_textobjects = {
			c = gen_spec.treesitter({
				a = "@conditional.outer",
				i = "@conditional.inner",
			}),
			o = gen_spec.treesitter({
				a = { "@block.outer", "@conditional.outer" },
				i = { "@block.inner", "@conditional.inner" },
			}),
		},
		search_method = "cover_or_nearest",
	},
	-- clue elsewhere
	pairs = {},
	-- tabline = {},
	-- git = {},
	icons = {},
	-- completion = {
	-- 	lsp_completion = {
	-- 		source_func = "completefunc",
	-- 		auto_setup = true,
	-- 	},
	-- mappings = {
	--
	-- },
	-- set_vim_settings = true
	-- },
	-- map = {},
	snippets = {},
	animate = {
		cursor = {
			enable = false,
		},
		scroll = {
			enable = true,
		},
		resize = {
			enable = true,
		},
		open = {
			enable = false,
		},
		close = {
			enable = false,
		},
	},
	-- hipatters = {
	-- 	highlighters = {
	-- 		hi.gen_highlighter.hex_color(),
	-- 	},
	-- },
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
	starter = {},
	basics = {},
	extra = {},
	jump = {},
	sessions = {
		autoread = true,
	},
	bufremove = {},
	indentscope = {},
	notify = {
		window = {
			max_width_share = 0.382,
		},
		lsp_progress = {
			enable = false,
		},
	},
}

local errors = {}

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

-- if not errors.notify then
-- 	vim.notify = MiniPlugins:get_plugin("notify").make_notify()
-- 	vim.notify("heheh")
-- end
