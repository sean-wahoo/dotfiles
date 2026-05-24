_G.ai_status_state = {
	ollama_online = false,
	ollama_model = "Offline",
	windsurf_online = false,
	windsurf_model = "Offline",
}

local function check_ollama()
	vim.system({ "curl", "-s", "http://localhost:11434/api/tags" }, { text = true }, function(obj)
		vim.schedule(function()
			if obj.code == 0 and obj.stdout and obj.stdout ~= "" then
				_G.ai_status_state.ollama_online = true
				local data = vim.json.decode(obj.stdout)
				if data and data.models and #data.models > 0 then
					_G.ai_status_state.ollama_model = data.models[1].name
					pcall(function()
						require("user.codecompanion")
					end)
				else
					_G.ai_status_state.ollama_model = "Offline"
					_G.ai_status_state.ollama_online = false
				end
			end
		end)
	end)
end

-- local function check_windsurf()
-- 	vim.system({ "curl", "-s", "http://localhost:11434/api/tags" }, { text = true }, function(obj)
-- 		vim.schedule(function()
-- 			if obj.code == 0 and obj.stdout and obj.stdout ~= "" then
-- 				_G.ai_status_state.windsurf_online = true
-- 				local data = vim.json.decode(obj.stdout)
-- 				if data and data.models and #data.models > 0 then
-- 					_G.ai_status_state.windsurf_model = data.models[1].name
-- 				else
-- 					_G.ai_status_state.windsurf_model = "Offline"
-- 					_G.ai_status_state.windsurf_online = false
-- 				end
-- 			end
-- 		end)
-- 	end)
-- end

check_ollama()
pcall(require, "user.windsurf")
-- check_windsurf()
