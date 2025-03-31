local ok, lspconfig = pcall(require, "lspconfig")

if not ok then
  print("lspconfig failed to load")
  return
end

local ok, lspsaga = pcall(require, "lspsaga")
if not ok then
  print("lspsaga failed to load")
  return
end

local ok, lsp_signature = pcall(require, "lsp_signature")
if not ok then
  print("lsp_signature failed to load")
end

local ok, lspkind = pcall(require, "lspkind")
if not ok then
  print("lspkind failed to load")
end


local lsp_signature_opts = {
  bind = true,
  doc_lines = 3,
  handler_opts = {
    border = "rounded"
  }
}

lspkind.setup {}

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
end
local on_attach = function(client, bufnr)
  lsp_keymaps(bufnr)
  require "lsp-format".on_attach(client, bufnr)
  lsp_signature.on_attach(lsp_signature_opts, bufnr)
end

local lsp_servers = {
  yamlls = {},
  terraformls = {},
  bashls = {},
  ansiblels = {
    filetypes = { 'yaml.ansible' }
  },
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT'
        },
        diagnostics = {
          globals = { 'vim' },
          update_in_insert = true
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("lua", true)
        }
      }
    }
  }
}

for server in pairs(lsp_servers) do
  local opts = lsp_servers[server]
  opts.capabilites = common_capabilities()
  opts.on_attach = on_attach
  lspconfig[server].setup(opts)
end

lspsaga.setup {
  border = 'single',
  folder_level = 0
}
