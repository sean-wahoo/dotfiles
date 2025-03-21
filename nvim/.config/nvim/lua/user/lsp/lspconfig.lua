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

local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not ok then
  print("cmp_nvim_lsp failed to load")
end

local capabilities = cmp_nvim_lsp.default_capabilities()
local on_attach = function(client, bufnr)
  require "lsp-format".on_attach(client, bufnr)
end

local lsp_servers = {
  terraformls = {},
  ansiblels = {
    filetypes = { 'yaml.ansible', 'yaml' }
  },
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' },
          update_in_insert = true
        }
      }
    }
  }
}

for server in pairs(lsp_servers) do
  local opts = lsp_servers[server]
  opts.capabilites = capabilities
  opts.on_attach = on_attach
  lspconfig[server].setup(opts)
end

-- lspconfig.lua_ls.setup {
--   settings = {
--   }
-- }
--
-- lspconfig.terraformls.setup {}
-- lspconfig.ansiblels.setup {
-- }

lspsaga.setup {}
