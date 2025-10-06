local ok, blink = pcall(require, "blink-cmp")
if not ok then
	print("blink failed")
	return
end

local m_ok, minuet = pcall(require, "minuet")

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
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
		providers = {
			minuet = {
				name = "minuet",
				module = "minuet.blink",
				async = true,
				timeout_ms = 3000,
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
		trigger = {
			prefetch_on_insert = false,
		},
	},
}

if m_ok then
	blink_config.keymap["<A-t>"] = minuet.make_blink_map()
end

blink.setup(blink_config)
