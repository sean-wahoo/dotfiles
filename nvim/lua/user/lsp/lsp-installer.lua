local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	return
end

lsp_installer.on_server_ready(function(server)
	local opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
	}

	if server.name == "sumneko_lua" then
		local sumneko_opts = require("user.lsp.settings.sumneko_lua")
		opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
	end
	if server.name == "jdtls" then
		local jdtls_opts = require("user.lsp.settings.jdtls")
		opts = vim.tbl_deep_extend("force", jdtls_opts, opts)
	end
	if server.name == "omnisharp" then
		local omnisharp_opts = require("user.lsp.settings.omnisharp")
		opts = vim.tbl_deep_extend("force", omnisharp_opts, opts)
	end

	server:setup(opts)
end)
