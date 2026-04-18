local files = io.popen([[ /usr/bin/ls -pa $HOME/.config/nvim/lsp | grep -v /]]):lines()

local lsp_servers = {}

for file in files do
  local lsp_name = string.gmatch(file, "([^.]+)")()
  lsp_name = lsp_name == 'lua-language-server' and "lua_ls" or lsp_name
  table.insert(lsp_servers, lsp_name)
end

local m_ok, mason = pcall(require, "mason")
if not m_ok then
  print("mason failed")
else
  mason.setup({
    registries = {
      "github:mason-org/mason-registry",
      "github:Crashdummyy/mason-registry"
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

local function toggle_diagnostics()
  local bufnr = vim.api.nvim_get_current_buf()

  local newSet = not vim.diagnostic.is_enabled({ bufnr = bufnr })
  vim.diagnostic.enable(newSet, { bufnr = bufnr })
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

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true, bufnr = bufnr }
  local keymap = vim.keymap.set
  local km_utils_ok, km_utils = pcall(require, "user.keymaps")
  if km_utils_ok then
    keymap = km_utils.keymap
  end
  keymap("n", "<leader>ldc", "<cmd>lua vim.lsp.buf.declaration()<CR>", "goto declaration", opts)
  keymap("n", "<leader>ldf", "<cmd>lua vim.lsp.buf.definition()<CR>", "goto definition", opts)
  keymap("n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", "signature help", opts)
  keymap("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", "code action", opts)
  keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", "hover", opts)
  keymap("n", "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<CR>", "goto implementation", opts)
  keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", "rename", opts)
  keymap("n", "<leader>ll", "<cmd>lua vim.diagnostic.open_float()<CR>", "open float", opts)
  keymap("n", "<leader>lT", toggle_diagnostics, "toggle diagnostics", opts)
  if trouble_ok then
    keymap("n", "<leader>lt", function()
      trouble.toggle("diagnostics")
    end, "trouble", opts)
  end
  if tid_ok then
    keymap("n", "<leader>lI", function()
      local cursor_diag = tid.get_diagnostic_under_cursor()
      cursor_diag.toggle()
    end, "toggle inline diagnostics (cursor)", opts)
    keymap("n", "<leader>lI", function()
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

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local on_attach = function(client, bufnr)
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
      callback = function()
        vim.lsp.buf.format({
          bufnr = bufnr,
        })
      end,
    })
  end
end
vim.diagnostic.config(diagnostic_config)

vim.lsp.config("*", {
  capabilites = common_capabilities(),
  on_attach = on_attach,
})
vim.lsp.enable(lsp_servers)
