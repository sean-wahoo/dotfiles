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
	interactions = {
		chat = {
			adapter = {
				name = "ollama",
				model = "qwen2.5-coder:14b",
			},
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
			adapter = "ollama",
			keymaps = {
				accept_change = {
					modes = { n = "ga" },
					description = "Accept Change (ollama)",
				},
				reject_change = {
					modes = { n = "gr" },
					description = "Reject Change (ollama)",
				},
			},
		},
		cli = {
			adapter = "ollama",
		},
		background = {
			adapter = {
				name = "ollama",
				model = "qwen-7b-instruct",
			},
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
		http = {
			ollama = function()
				return adapters.extend("ollama", {
					env = {
						url = "http://localhost:11434",
					},
					headers = {
						["Content-Type"] = "application/json",
					},
					parameters = {
						sync = true,
					},
				})
			end,
		},
	},
}

cc.setup(cc_config)
