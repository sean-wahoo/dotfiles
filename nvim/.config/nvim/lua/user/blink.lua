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
		default = { "cursortab", "lazydev", "lsp", "buffer", "snippets", "path", "emoji" },
		providers = {
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
			cursortab = {
				module = "cursortab.blink",
				name = "cursortab",
				async = true,
				timeout_ms = 5000,
			},
			-- avante = {
			--   name = "Avante",
			--   module = "blink-cmp-avante",
			-- },
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				score_offset = 100,
			},
		},
	},
	completion = {
		menu = {
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
