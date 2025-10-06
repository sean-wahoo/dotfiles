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

local lspkind_ok, lspkind = pcall(require, "lspkind")
if not lspkind_ok then
	print("lspkind failed to load")
else
	lspkind.setup({})
end

local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true }
	local keymap = vim.api.nvim_buf_set_keymap
	local km_utils_ok, km_utils = pcall(require, "user.keymaps")
	if km_utils_ok then
		keymap = km_utils.buf_keymap
	end
	-- keymap(bufnr, "n", "<leader>lD", "<cmd>lua vim.lsp.buf.declaration()<CR>", "goto declaration", opts)
	-- keymap(bufnr, "n", "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<CR>", "goto definition", opts)
	-- keymap(bufnr, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", "signature help", opts)
	-- keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", "code action", opts)
	-- keymap(bufnr, "n", "K", "<cmd>Lspsaga hover_doc<CR>", "hover", opts)
	-- keymap(bufnr, "n", "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<CR>", "goto implementation", opts)
	-- keymap(bufnr, "n", "<leader>ll", "<cmd>lua vim.diagnostic.open_float()<CR>", "open float", opts)
	-- keymap(bufnr, "n", l<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", "rename", opts)
	keymap(bufnr, "n", "<leader>ll", "<cmd>lua vim.diagnostic.open_float()<CR>", "open float", opts)
end

vim.diagnostic.config({
	signs = {
		text = {
			-- [vim.lsp.]
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
	},
})

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
	return capabilities
end

local on_attach = function(client, bufnr)
	lsp_keymaps(bufnr)
end

vim.lsp.config("*", {
	capabilites = common_capabilities(),
	on_attach = on_attach,
})
vim.lsp.config("ts_ls", {
	capabilites = common_capabilities(),
	on_attach = on_attach,
})
vim.lsp.enable(lsp_servers)
