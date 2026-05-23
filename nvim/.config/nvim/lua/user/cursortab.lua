local cursortab_ok, cursortab = pcall(require, "cursortab")
if not cursortab_ok then
	print("cursortab oopsie!")
	return
end

-- write a function that says ass 5 times

local obj = {
	a = "b",
	b = "c",
	c = "d",
	d = "e",
	e = "f",
	f = "g",
	g = "h",
	h = "i",
}

local cursortab_config = {
	enabled = true,
	log_level = "debug",
	-- system_prompt = "You are a code completion engine. Provide only the code. No explanations. No markdown. If a comment is needed for context, use the language's comment syntax.",

	provider = {
		-- type = "sweep",
		type = "sweep",
		url = "http://localhost:8050",
		completion_timeout = 5000,
		-- model = "qwen2.5-coder:7b",
		-- api_key_env = "OPENWEBUI_API_KEY",
		-- model = "nishtahir/zeta:7b",
		-- model = "maternion/sweep-next-edit-1.5B",
		-- max_tokens = 2048,
		-- max_context = 500,
		-- context_window = 500,
		temperature = 0,
		fim_tokens = {
			prefix = "<|fim_prefix|>",
			suffix = "<|fim_suffix|>",
			middle = "<|fim_middle|>",
		},
		-- num_predict = 128,
		-- },
	},

	-- provider = {
	--   type = "sweep",
	--   url = "http://localhost:8000",
	--   max_tokens = 2048,
	--   completion_timeout = 5000
	-- },
	behavior = {
		idle_completion_delay = 500,
		text_change_debounce = 500,
		ignore_filetypes = {
			"",
			"terminal",
		},
	},
	ui = {
		jump = {
			symbol = "", -- Symbol shown for jump points
			text = " TAB ", -- Text displayed after jump symbol
			show_distance = true, -- Show line distance for off-screen jumps
		},
	},
	blink = {
		enabled = true,
		ghost_text = true,
	},
}
local M = {
	name = "cursortab",
	active = false,
}

M.enable = function(self)
	if not self.active then
		cursortab.setup(cursortab_config)
		self.active = true
	end
end

return M
