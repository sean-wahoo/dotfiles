-- local ok, cosmic = pcall(require, 'cosmic-ui')
-- if not ok then
--   print('cosmic failed to load')
--   return
-- end
-- cosmic.setup {
--
-- }
local ok, noice = pcall(require, 'noice')
if not ok then
  print('noice failed to load')
  return
end

noice.setup {
  cmdline = {
    enabled = true,
    inc_rename = false,
  },
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  routes = {
    {
      filter = {
        event = "msg_show",
        any = {
          { find = "%d+L, %d+B" },
          { find = "; after #%d+" },
          { find = "; before #%d+" },
        },
      },
      view = "mini",
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = false,
    lsp_doc_border = true
  },
  notify = {
    enabled = false
  },

}
