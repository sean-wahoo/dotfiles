local default_workspace = {
  library = {
    vim.fn.expand "$VIMRUNTIME",
  },
  maxPreload = 20,
  preloadFileSize = 10000,
  checkThirdParty = false
}

local add_packages_to_workspace = function (packages, config)
  local runtimedirs = vim.api.nvim__get_runtime({ "lua" }, true, { is_lua = true })
  local workspace = config.settings.Lua.workspace
  for _, v in pairs(runtimedirs) do
    for _, pack in ipairs(packages) do
      if v:match(pack) and not vim.tbl_contains(workspace.library, v) then
        table.insert(workspace.library, v)
      end
    end
  end
end

local lspconfig_status_ok, lspconfig = pcall(require, 'lspconfig')

if not lspconfig_status_ok then
  print("lua_ls couldn't load?")
  return
end

local make_on_new_config = function(on_new_config, _) 
  return lspconfig.util.add_hook_before(on_new_config, function(new_config, _)
    local server_name = new_config.name

    if server_name ~= "lua_ls" then
      return
    end
    local plugins = { "plenary.nvim", "telescope.nvim", "nvim-treesitter", "LuaSnip" }
    add_packages_to_workspace(plugins, new_config)
  end)
end

lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
  on_new_config = make_on_new_config(lspconfig.util.default_config.on_new_config)
})

return {
  settings = {
    Lua = {
      hint = {
        setType = true,
        enable = true
      },
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        -- globals = {'vim'}
      },
      -- workspace = {
      --   maxPreload = 100,
      --   checkThirdParty = false,
      --   library = {
      --     [vim.fn.stdpath("config") .. "/lua"] = true,
      --   }
      -- },
      -- workspace = vim.tbl_extend("error", default_workspace, { checkThirdParty = false }),
      workspace = default_workspace,
      telemetry = {
        enable = false
      }
    }
  }
}
