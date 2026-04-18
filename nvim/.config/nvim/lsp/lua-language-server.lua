return {
  cmd = { "lua-language-server" },
  root_markers = { ".luarc.json", "init.lua" },
  filetypes = { "lua" },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
        update_in_insert = true,
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("lua", true),
        -- checkThirdParty = false,
      },
      maxPreload = 1000,
      preloadFileSize = 100,
    },
  },
}

