local gp_ok, gp = pcall(require, "gp")
if not gp_ok then
	print("gp oopsie!")
	return
end

local gp_config = {
	log_level = vim.log.levels.DEBUG,
	log_file = vim.fn.stdpath("data") .. "/gp.nvim.log",
	-- ollama = {
	-- 	endpoint = "http://localhost:11434/v1/chat/completions",
	-- },
	-- 1. Use the Ollama /v1 endpoint
	-- openai_api_endpoint = "http://localhost:11434/v1/chat/completions",
	--
	-- -- 2. Force it to skip the vault search
	-- openai_api_key = "ollama", -- Any string works here
	--

	-- 3. This is the crucial line: it tells gp NOT to look for a secret command
	-- openai_api_key_cmd = "",
	agents = {
		{
			name = "CoderLocal",
			chat = true,
			command = true,
			provider = "ollama",
			model = {
				model = "qwen2.5-coder:14b",
				architecture = "ollama",
				temperature = 0.2,
			},
			system_prompt = "You are a Senior Software Engineer. Use Sean's local context and keep code concise.",
		},
		{
			name = "LogicLocal",
			chat = true,
			command = false,
			provider = "ollama",
			model = {
				model = "qwen2.5-coder:14b-instruct",
				temperature = 0.6,
				architecture = "ollama",
			},
			system_prompt = "You are a logical reasoning assistant. Think step-by-step to solve Sean's problems.",
		},
	},
	default_chat_agent = "LogicLocal",
	default_command_agent = "CoderLocal",
	hooks = {
		-- Explain the code in a new buffer
		Explain = function(gp, params)
			local template = "I have the following code:\n\n"
				.. "```{{filetype}}\n{{selection}}\n```\n\n"
				.. "Please explain what this does and how it interacts with a DataScript graph."
			local agent = gp.get_chat_agent()
			gp.Prompt(params, gp.Target.enew, agent, template)
		end,

		-- Unit Test Generator (Crucial for job-ready code!)
		UnitTests = function(gp, params)
			local template = "Write comprehensive unit tests for the following code:\n\n"
				.. "```{{filetype}}\n{{selection}}\n```"
			local agent = gp.get_code_agent()
			gp.Prompt(params, gp.Target.enew, agent, template)
		end,
	},
	openai_api_key = "dummy_secret",
	providers = {
		ollama = {
			endpoint = "http://localhost:11434/v1/chat/completions",
			disable = false,
			secret = "ollama",
		},
		openai = {},
	},
}
local M = {
	name = "gp",
	active = false,
}

M.enable = function(self)
	if not self.active then
		gp.setup(gp_config)

		local gp_dispatcher = require("gp.dispatcher")
		local original_process_lines = gp_dispatcher.process_lines
		gp_dispatcher.process_lines = function(self, lines, qt)
			for i, line in ipairs(lines) do
				if qt.provider == "ollama" and type(line) == "string" then
					-- Strip the "data: " prefix Ollama adds to SSE streams
					lines[i] = line:gsub("^data: ", "")
				end
			end
			return original_process_lines(self, lines, qt)
		end

		self.active = true
	end
end

return M
