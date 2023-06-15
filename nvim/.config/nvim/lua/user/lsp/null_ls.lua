local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
  return
end

local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local cb = function (bufnr)
  vim.lsp.buf.format({
    bufnr = bufnr,
    -- filter = function (client)
    --   return client.name == "null-ls"
    -- end
  })
end

null_ls.setup {
  sources = {
    -- diagnostics.eslint_d,
    diagnostics.tsc,
    formatting.prismaFmt,
    formatting.eslint_d
  },
  on_attach = function(client, bufnr)
    if client.supports_method('textDocument/formatting') then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function ()
          print(client.name)
          cb(bufnr)
        end
      })
    end
  end
}
