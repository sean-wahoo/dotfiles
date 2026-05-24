local files = io.popen([[ /usr/bin/ls -pa $HOME/.config/nvim/lsp | grep -v /]]):lines()

local lsp_servers = {}

for file in files do
	local lsp_name = string.gmatch(file, "([^.]+)")()
	lsp_name = lsp_name == "lua-language-server" and "lua_ls" or lsp_name
	table.insert(lsp_servers, lsp_name)
end

local m_ok, mason = pcall(require, "mason")
if not m_ok then
	print("mason failed")
else
	mason.setup({
		registries = {
			"github:mason-org/mason-registry",
			"github:Crashdummyy/mason-registry",
		},
		ensure_installed = {
			"lua-language-server",
			"vtsls",
			"bash-language-server",
			"rustfmt",
			"rust-analyzer",
		},
	})
end

local diagnostic_config = {
	float = { border = "rounded" },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "󰳧",
		},
	},
}

local tid_ok, tid = pcall(require, "tiny-inline-diagnostic")
if not tid_ok then
	print("tid oopsie!")
else
	tid.setup({
		preset = "powerline",
		transparent_bg = true,
		hi = {
			mixing_color = "#272e33",
		},
		options = {
			virt_texts = {
				priority = 200,
			},
			multilines = {
				enabled = true,
			},
			add_messages = {
				display_count = true,
			},
			show_source = {
				enabled = true,
			},
		},
	})
	diagnostic_config.virtual_text = false
end
local trouble_ok, trouble = pcall(require, "trouble")

local keymap = require("user.keymaps").keymap
local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }

	opts.desc = "lsp show declarations"
	keymap("n", "gD", function()
		Snacks.picker.lsp_declarations()
	end, opts)

	opts.desc = "lsp show definition"
	keymap("n", "gd", function()
		Snacks.picker.lsp_definitions()
	end, opts)
	opts.desc = "signature help"
	keymap("n", "<leader>ls", function()
		vim.lsp.buf.signature_help()
	end, opts)
	-- keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", "hover", opts)

	opts.desc = "lsp hover"
	keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	opts.desc = "goto implementation"
	keymap("n", "gi", function()
		Snacks.picker.lsp_implementations()
	end, opts)
	opts.desc = "rename"

	keymap("n", "gy", function()
		Snacks.picker.lsp_type_definitions()
	end, opts)

	opts.desc = "open float"
	keymap("n", "go", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)

	opts.desc = "code actions"
	keymap("n", "<leader>la", function()
		vim.lsp.buf.code_action()
	end, opts)
	opts.desc = "lsp rename"
	keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

	-- ~/.config/nvim/init.lua

	-- 1. Store Neovim's native fallback hover UI logic
	local native_hover_handler = vim.lsp.handlers["textDocument/hover"]

	-- 2. Build a custom middleware interceptor
	vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
		-- If the server sends an error or completely empty content payload, stop instantly
		if err or not (result and result.contents) then
			return
		end

		-- Normalize the message block into a clear string
		local val = ""
		if type(result.contents) == "table" and result.contents.value then
			val = result.contents.value
		else
			val = tostring(result.contents)
		end

		-- 🔥 THE FINAL SHIELD:
		-- If vtsls passes the literal blank string notification, bypass the handler.
		-- This kills BOTH the floating window AND the background vim.notify alert.
		if val:match("No information available") then
			return
		end

		-- 3. Otherwise, execute normal hover processing safely
		native_hover_handler(err, result, ctx, config)
	end

	if trouble_ok then
		opts.desc = "trouble"
		keymap("n", "<leader>lt", function()
			trouble.toggle("diagnostics")
		end, opts)
	end
	if tid_ok then
		opts.desc = "toggle inline diagnostics (cursor)"
		keymap("n", "<leader>lI", function()
			local cursor_diag = tid.get_diagnostic_under_cursor()
			cursor_diag.toggle()
		end, opts)

		opts.desc = "toggle inline diagnostics (global)"
		keymap("n", "<leader>lI", function()
			tid.toggle()
		end, opts)
	end
end

local function common_capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	}
	local ok, blink_cmp = pcall(require, "blink.cmp")
	if ok then
		capabilities = blink_cmp.get_lsp_capabilities(capabilities)
	end

	capabilities.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}
	return capabilities
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local lsp_on_attach = function(client, bufnr)
	lsp_keymaps(bufnr)
	local wd_ok, wd = pcall(require, "workspace-diagnostics")

	if wd_ok then
		local wd_success, _ = pcall(function()
			wd.populate_workspace_diagnostics(client, bufnr)
		end)
		if not wd_success then
			print("workspace diagnostics fail!")
		end
	end
	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function(args)
				vim.lsp.buf.format({
					bufnr = args.buf,
				})
			end,
		})
	end
end
vim.diagnostic.config(diagnostic_config)

vim.lsp.config("*", {
	capabilites = common_capabilities(),
	on_attach = lsp_on_attach,
})
vim.lsp.enable(lsp_servers)

require("user.null_ls")
