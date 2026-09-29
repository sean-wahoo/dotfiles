local cc_ok, cc = pcall(require, "codecompanion")
if not cc_ok then
	print("cc oopsie!")
	return
end

local adapters_ok, adapters = pcall(require, "codecompanion.adapters")
if not adapters_ok then
	print("cc adapters oopsie!")
	return
end

local cc_config = {
	-- mcp = {
	-- 	servers = {
	-- 		["nextjs"] = {
	-- 			cmd = { "npx", "-y", "next-devtools-mcp@latest" },
	-- 			env = {
	-- 				NEXTJS_DEFAULT_PORT = "3010",
	-- 			},
	-- 		},
	-- 	},
	-- 	opts = {
	-- 		default_servers = { "nextjs" },
	-- 	},
	-- },
	throttle_rendering = false,
	interactions = {
		chat = {
			adapter = "cline_cli",
			-- adapter = {
			-- 	-- name = "openai",
			-- 	-- model = "cline-pass/deepseek-v4-flash",
			-- },
			-- tools = {
			-- 	["mcp"] = {
			-- 		callback = function()
			-- 			return require("mcphub.extensions.codecompanion")
			-- 		end,
			-- 		description = "nextjs",
			-- 		opts = {
			-- 			requires_approval = false,
			-- 		},
			-- 	},
			-- },
			slash_commands = {
				["git_files"] = {
					description = "List git files",
					callback = function(chat)
						local handle = io.popen("git ls-files")
						if handle ~= nil then
							local result = handle:read("*a")
							handle:close()
							chat:add_context({ content = result }, "git", "<git_files>")
						else
							return vim.notify(
								"No git files available",
								vim.log.levels.INFO,
								{ title = "CodeCompanion" }
							)
						end
					end,
					opts = {
						contains_code = false,
					},
				},
			},
		},
		inline = {
			adapter = "cline_cli",
			-- adapter = "openai",
			-- keymaps = {
			-- 	accept_change = {
			-- 		modes = { n = "ga" },
			-- 		description = "Accept Change (openai)",
			-- 	},
			-- 	reject_change = {
			-- 		modes = { n = "gr" },
			-- 		description = "Reject Change (openai)",
			-- 	},
			-- },
		},
		cli = {
			adapter = "cline_cli",
			-- adapter = "openai",
		},
		background = {
			adapter = "cline_cli",
			-- adapter = {
			-- 	name = "openai",
			-- 	model = "cline-pass/deepseek-v4-flash",
			-- },
		},
	},
	display = {
		action_pallete = {
			opts = {
				style = "fidget",
			},
		},
	},
	adapters = {
		cline_cli = function()
			return adapters.extend("cline_cli", {
				defaults = {
					model = "meta-llama/llama-3.3-70b-instruct",
				},
			})
		end,
		cline_pass = function()
			return adapters.extend("openai_compatible", {
				name = "cline_pass",
				env = {
					url = "https://cline.bot",
					api_key = "CLINE_PASS_API_KEY",
					headers = {
						["Accept"] = "text/event-stream",
						["Cache-Control"] = "no-cache",
						["Connection"] = "keep-alive",
						["X-Cline-Stream"] = "true",
					},
				},
				schema = "openai",
				parameters = {
					model = "meta-llama/llama-3.3-70b-instruct",
					-- model = "cline-pass/deepseek-v4-flash",
				},
			})
		end,
		openai = function()
			return adapters.extend("openai_compatible", {
				name = "cline_pass",
				env = {
					url = "https://cline.bot",
					api_key = "CLINE_PASS_API_KEY",
					headers = {
						["Accept"] = "text/event-stream",
						["Cache-Control"] = "no-cache",
						["Connection"] = "keep-alive",
						["X-Cline-Stream"] = "true",
					},
				},
				schema = "openai",
				parameters = {
					model = "meta-llama/llama-3.3-70b-instruct",
					-- model = "cline-pass/deepseek-v4-flash",
				},
			})
			-- return {
			-- 	name = "openai",
			-- 	env = {
			-- 		url = "https://api.cline.bot/api/v1",
			-- 		api_key = "CLINE_PASS_API_KEY",
			-- 		headers = {
			-- 			["Accept"] = "text/event-stream",
			-- 			["Cache-Control"] = "no-cache",
			-- 			["Connection"] = "keep-alive",
			-- 			["X-Cline-Stream"] = "true",
			-- 		},
			-- 	},
			-- 	schema = "openai",
			-- 	parameters = {
			-- 		model = "cline-pass/deepseek-v4-flash",
			-- 	},
			-- }
		end,
	},
}

cc.setup(cc_config)
