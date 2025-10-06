local ok, minuet = pcall(require, "minuet")
if not ok then
	print("minuet failed")
	return
end

local v_ok, v = pcall(require, "vectorcode")

if not v_ok then
	print("vectorcode failed")
else
	v.setup({
		n_query = 1,
	})
end

local vconfig_ok, vconfig = pcall(require, "vectorcode.config")
local vcacher = nil
if not vconfig_ok then
	print("vectorcode failed")
else
	vcacher = vconfig.get_cacher_backend()
end

local RAG_Context_Window_Size = 8000

minuet.setup({
	lsp = {
		enabled_ft = { "lua", "tsx", "typescript", "jsx", "javascript" },
		enabled_auto_trigger_ft = {},
		warn_on_blink_or_cmp = false,
	},
	provider = "openai_fim_compatible",
	n_completions = 1,
	context_window = 512,
	request_timeout = 5,
	-- notify = "debug",
	virtualtext = {
		auto_trigger_ft = {},
		keymap = {
			accept = "<A-A>",
			accept_line = "<A-a>",
			accept_n_lines = "<A-z>",
			prev = "<A-[>",
			next = "<A-]>",
			dismiss = "<A-e>",
		},
	},

	provider_options = {
		openai_fim_compatible = {
			api_key = "TERM",
			name = "Ollama",
			end_point = "http://10.69.1.10:30068/v1/completions",
			model = "qwen2.5-coder:0.5b",
			optional = {
				max_tokens = 56,
				top_p = 0.9,
			},
			template = {
				prompt = function(pref, suff, _)
					local prompt_message = ""
					if vconfig_ok then
						for _, file in ipairs(vcacher.query_from_cache(0)) do
							prompt_message = prompt_message .. "<|file_sep|>" .. file.path .. "\n" .. file.document
						end
					end

					prompt_message = vim.fn.strcharpart(prompt_message, 0, RAG_Context_Window_Size)

					return prompt_message .. "<|fim_prefix|>" .. pref .. "<|fim_suffix|>" .. suff .. "<|fim_middle|>"
				end,
				suffix = false,
			},
		},
	},
})
