local dap_ok, dap = pcall(require, "dap")
if not dap_ok then
	print("dap oopsie!")
	return
end
local dapui_ok, dapui = pcall(require, "dapui")
if not dapui_ok then
	print("dapui oopsie!")
	return
end

-- local c_dap_port =

---@type dap.Adapter
local lldb_config = {
	type = "server",
	port = "${port}",
	executable = {
		command = "codelldb",
		args = { "--port", "${port}" },
	},
}

---@type dap.Config
local c_config = {
	{
		name = "xmake - debug active target",
		type = "codelldb",
		request = "launch",
		program = function()
			local handle = io.popen("xmake show -t targetpath")
			if handle then
				local result = handle:read("*a")
				handle:close()
				local path = result:gsub("%s+", "")
				if path ~= "" then
					return path
				end
				return result
			end
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = {},
		preLaunchTasks = "xmake",
		runInTerminal = false,
	},
}

dap.adapters.codelldb = lldb_config
dap.configurations.c = c_config

dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end
