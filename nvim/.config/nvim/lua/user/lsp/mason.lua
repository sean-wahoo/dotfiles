local status_ok, mason = pcall(require, "mason")
if not status_ok then
  return
end

local status_ok_1, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok_1 then
  return
end

local servers = {
  'lua_ls',
  'tsserver',
  'prismals',
  'gopls',
  "tailwindcss",
  "intelephense",
  "pyright"
}

local settings = {
  ui = {
    border = "rounded",
    icons = {
      package_installed = "◍",
      package_pending = "◍",
      package_uninstalled = "◍",
    },
  },
  log_level = vim.log.levels.INFO,
  max_concurrent_installers = 4,
}

mason.setup(settings)
mason_lspconfig.setup {
  ensure_installed = servers,
  automatic_installation = true
}

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
  return
end

local opts = {}

for _, server in pairs(servers) do
  opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities
  }

  server = vim.split(server, "@")[1]

  if server == "tsserver" then
    local tsserver_opts = require "user.lsp.settings.tsserver"
    opts = vim.tbl_deep_extend("force", tsserver_opts, opts)
  end

  if server == "lua_ls" then
    -- local l_status_ok, lua_dev = pcall(require, "lua-dev")
    -- if not l_status_ok then
    --   return
    -- end
    local lua_ls_opts = require "user.lsp.settings.lua_ls"
    -- opts = vim.tbl_deep_extend("force", lua_ls_opts, opts)
    -- opts = vim.tbl_deep_extend("force", require("lua-dev").setup(), opts)
    -- local luadev = lua_dev.setup {
    --   --   -- add any options here, or leave empty to use the default settings
    --   -- lspconfig = opts,
    --   lspconfig = {
    --     on_attach = opts.on_attach,
    --     capabilities = opts.capabilities,
    --     --   -- settings = opts.settings,
    --   },
    -- }
    lspconfig.lua_ls.setup(lua_ls_opts)
    goto continue
  end
  lspconfig[server].setup(opts)
  ::continue::
end
