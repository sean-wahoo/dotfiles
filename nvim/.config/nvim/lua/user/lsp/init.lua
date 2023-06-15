M = {}
local status_ok, _ = pcall(require, 'lspconfig')
if not status_ok then
  print "LSP couldn't be loaded!"
  return
end

M.server_capabilities = function ()
  local active_clients = vim.lsp.get_active_clients()
  local active_client_map = {}

  for i, v in ipairs(active_clients) do
    active_client_map[v.name] = i
  end

  vim.ui.select(vim.tbl_keys(active_client_map), {
    prompt = "Select client:",
    format_item = function(item)
      return "cabailities for: " .. item
    end
  }, function (choice)
    print(vim.inspect(vim.lsp.get_active_clients()[active_client_map[choice]].server_capabilities.executeCommandProvider))
    vim.pretty_print(vim.lsp.get_active_clients()[active_client_map[choice]].server_capabilities)
  end)
end

require "user.lsp.mason"
require "user.lsp.handlers".setup()
require "user.lsp.null_ls"

vim.fn.sign_define(
  "LspDiagnosticsSignError",
  { texthl = "LspDiagnosticsSignError", text = "󰅚", numhl = "LspDiagnosticsSignError" }
)
vim.fn.sign_define(
  "LspDiagnosticsSignWarning",
  { texthl = "LspDiagnosticsSignWarning", text = "", numhl = "LspDiagnosticsSignWarning" }
)
vim.fn.sign_define(
  "LspDiagnosticsSignHint",
  { texthl = "LspDiagnosticsSignHint", text = "󰌶", numhl = "LspDiagnosticsSignHint" }
)
vim.fn.sign_define(
  "LspDiagnosticsSignInformation",
  { texthl = "LspDiagnosticsSignInformation", text = "", numhl = "LspDiagnosticsSignInformation" }
)

return M
