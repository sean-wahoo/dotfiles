local files = io.popen([[ /usr/bin/ls -pa $HOME/.config/nvim/lsp | grep -v /]]):lines()

local lsp_servers = {}

for file in files do
	local lsp_name = string.gmatch(file, "([^.]+)")()
	table.insert(lsp_servers, lsp_name)
end

local m_ok, mason = pcall(require, "mason")
if not m_ok then
	print("mason failed")
else
	mason.setup({
		ensure_installed = { "lua-language-server", "typescript-language-server", "bash-language-server" },
	})
end

local lspsaga_ok, lspsaga = pcall(require, "lspsaga")
if not lspsaga_ok then
	print("lspsaga failed to load")
else
	lspsaga.setup({
		lightbulb = {
			enable = false,
		},
		definition = {
			keys = {
				edit = "o",
			},
		},
	})
end

local function toggle_diagnostics()
	local bufnr = vim.api.nvim_get_current_buf()

	local newSet = not vim.diagnostic.is_enabled({ bufnr = bufnr })
	vim.diagnostic.enable(newSet, { bufnr = bufnr })
end

local diagnostic_config = {
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
		-- transparent_bg = true,
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

local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true }
	local keymap = vim.api.nvim_buf_set_keymap
	local km_utils_ok, km_utils = pcall(require, "user.keymaps")
	if km_utils_ok then
		keymap = km_utils.buf_keymap
	end
	keymap(bufnr, "n", "<leader>ldc", "<cmd>lua vim.lsp.buf.declaration()<CR>", "goto declaration", opts)
	keymap(bufnr, "n", "<leader>ldf", "<cmd>Lspsaga goto_definition<CR>", "goto definition", opts)
	keymap(bufnr, "n", "<leader>lD", "<cmd>Lspsaga peek_definition<CR>", "goto definition", opts)
	keymap(bufnr, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", "signature help", opts)
	keymap(bufnr, "n", "<leader>la", "<cmd>Lspsaga code_action()<CR>", "code action", opts)
	keymap(bufnr, "n", "K", "<cmd>Lspsaga hover_doc<CR>", "hover", opts)
	-- keymap(bufnr, "n", "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<CR>", "goto implementation", opts)
	keymap(bufnr, "n", "<leader>lr", "<cmd>Lspsaga rename<CR>", "rename", opts)
	keymap(bufnr, "n", "<leader>ll", "<cmd>Lspsaga show_line_diagnostics<CR>", "open float", opts)
	keymap(bufnr, "n", "<leader>lT", toggle_diagnostics, "toggle diagnostics", opts)
	if trouble_ok then
		keymap(bufnr, "n", "<leader>lt", function()
			trouble.toggle("diagnostics")
		end, "trouble", opts)
	end
	if tid_ok then
		keymap(bufnr, "n", "<leader>li", function()
			local cursor_diag = tid.get_diagnostic_under_cursor()
			cursor_diag.toggle()
		end, "toggle inline diagnostics (cursor)", opts)
		keymap(bufnr, "n", "<leader>li", function()
			tid.toggle()
		end, "toggle inline diagnostics (global)", opts)
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

local on_attach = function(client, bufnr)
	lsp_keymaps(bufnr)
	local wd_ok, wd = pcall(require, "workspace-diagnostics")
	if wd_ok then
		wd.populate_workspace_diagnostics(client, bufnr)
	end
end
vim.diagnostic.config(diagnostic_config)

vim.lsp.config("*", {
	capabilites = common_capabilities(),
	on_attach = on_attach,
})
vim.lsp.enable(lsp_servers)
