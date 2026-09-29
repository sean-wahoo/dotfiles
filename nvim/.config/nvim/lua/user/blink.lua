local ok, blink = pcall(require, "blink-cmp")
if not ok then
	print("blink failed")
	return
end

local kind_icons = {
	-- LLM Provider icons
	claude = "󰋦",
	openai = "󱢆",
	codestral = "󱎥",
	gemini = "",
	Groq = "",
	Openrouter = "󱂇",
	Ollama = "󰳆",
	["Llama.cpp"] = "󰳆",
	Deepseek = "",
}

local source_icons = {
	minuet = "󱗻",
	orgmode = "",
	otter = "󰼁",
	nvim_lsp = "",
	lsp = "",
	buffer = "",
	luasnip = "",
	snippets = "",
	path = "",
	git = "",
	tags = "",
	cmdline = "󰘳",
	latex_symbols = "",
	cmp_nvim_r = "󰟔",
	codeium = "󰩂",
	-- FALLBACK
	fallback = "󰜚",
}

local blink_config = {
	signature = {
		enabled = true,
	},
	appearance = {
		use_nvim_cmp_as_default = true,
		nerd_font_variant = "normal",
		kind_icons = kind_icons,
	},
	keymap = {
		preset = "default",
		-- Prefer an inline suggestion (e.g. neocodeium) over blink's own items.
		-- Each custom function returns nil when there is no inline suggestion so
		-- blink's built-in command runs next, keeping normal behaviour intact.
		["<C-y>"] = {
			function()
				local nc_ok, neocodeium = pcall(require, "neocodeium")
				if nc_ok and neocodeium.visible() then
					neocodeium.accept()
					return true
				end
			end,
			"select_and_accept",
			"fallback",
		},
		["<C-e>"] = {
			function(cmp)
				local nc_ok, neocodeium = pcall(require, "neocodeium")
				if nc_ok and neocodeium.visible() then
					neocodeium.clear()
					-- The inline suggestion is gone, so let blink offer its own
					-- completions again (otherwise the menu stays hidden until
					-- the next trigger/keystroke).
					vim.schedule(function()
						cmp.show()
					end)
					return true
				end
			end,
			"cancel",
			"fallback",
		},
		["<C-n>"] = {
			function()
				local nc_ok, neocodeium = pcall(require, "neocodeium")
				if nc_ok and neocodeium.visible() then
					neocodeium.cycle_or_complete(1)
					return true
				end
			end,
			"select_next",
			"fallback",
		},
		["<C-p>"] = {
			function()
				local nc_ok, neocodeium = pcall(require, "neocodeium")
				if nc_ok and neocodeium.visible() then
					neocodeium.cycle_or_complete(-1)
					return true
				end
			end,
			"select_prev",
			"fallback",
		},
	},
	snippets = {
		preset = "luasnip",
	},
	cmdline = {
		completion = {
			ghost_text = {
				enabled = false,
			},
		},
	},
	fuzzy = {
		implementation = "prefer_rust_with_warning",
		sorts = {
			"exact",
			function(a, b)
				if (a.client_name == nil or b.client_name == nil) or (a.client_name == b.client_name) then
					return
				end
			end,
			"score",
			"sort_text",
		},
	},
	sources = {
		default = { "lazydev", "lsp", "buffer", "snippets", "path" },
		providers = {
			-- codeium = {
			-- 	name = "Codeium",
			-- 	module = "codeium.blink",
			-- 	timeout_ms = 2000,
			-- 	score_offset = -5,
			-- 	async = true,
			-- },
			env = {
				name = "Env",
				module = "blink-cmp-env",
				opts = {
					item_kind = require("blink.cmp.types").CompletionItemKind,
					show_braces = false,
					show_documentation_window = true,
				},
			},
			emoji = {
				module = "blink-emoji",
				name = "Emoji",
				score_offset = 15,
				opts = {
					insert = true,
					trigger = function()
						return { ":" }
					end,
					should_show_items = function()
						return vim.tbl_contains({ "gitcommit", "markdown" }, vim.o.filetype)
					end,
				},
			},
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				score_offset = 100,
			},
		},
	},
	completion = {
		menu = {
			-- Yield the menu to an inline suggestion (e.g. neocodeium) whenever
			-- one is visible, so the two never compete on screen.
			auto_show = function()
				local nc_ok, neocodeium = pcall(require, "neocodeium")
				return not (nc_ok and neocodeium.visible())
			end,
			draw = {
				columns = {
					{ "label", "label_description", gap = 1 },
					{ "kind_icon", "kind" },
					{ "source_icon" },
				},
				components = {
					source_icon = {
						-- don't truncate source_icon
						ellipsis = false,
						text = function(ctx)
							return source_icons[ctx.source_name:lower()] or source_icons.fallback
						end,
						highlight = "BlinkCmpSource",
					},
				},
			},
		},
		documentation = { auto_show = true },
		trigger = {
			prefetch_on_insert = false,
		},
	},
}

blink.setup(blink_config)
