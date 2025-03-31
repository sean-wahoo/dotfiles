local files = io.popen(
  [[ /usr/bin/ls -pa $HOME/.config/nvim/lsp | grep -v /]]
):lines()

local lsp_servers = {}

for file in files do
  print(file)
  local lsp_name = string.gmatch(file, "([^.]+)")()
  table.insert(lsp_servers, lsp_name)
end

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  local keymap = vim.api.nvim_buf_set_keymap
  local km_utils_ok, km_utils = pcall(require, "user.keymaps")
  if km_utils_ok then
    keymap = km_utils.buf_keymap
  end
  keymap(bufnr, "n", "<leader>lD", "<cmd>lua vim.lsp.buf.declaration()<CR>", "goto declaration", opts)
  keymap(bufnr, "n", "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<CR>", "goto definition", opts)
  keymap(bufnr, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", "signature help", opts)
  keymap(bufnr, "n", "<leader>lK", "<cmd>lua vim.lsp.buf.hover()<CR>", "hover", opts)
  keymap(bufnr, "n", "<leader>lI", "<cmd>lua vim.lsp.buf.implementation()<CR>", "goto implementation", opts)
  keymap(bufnr, "n", "<leader>ll", "<cmd>lua vim.diagnostic.open_float()<CR>", "open float", opts)
end

local function common_capabilities()
  local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok then
    return cmp_nvim_lsp.default_capabilities()
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits"
    }
  }
  return capabilities
end

local on_attach = function(client, bufnr)
  lsp_keymaps(bufnr)
end

vim.lsp.config('*', {
  capabilites = common_capabilities(),
  on_attach = on_attach
})

vim.lsp.enable(lsp_servers)
