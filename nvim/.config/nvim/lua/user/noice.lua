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
  views = {
    cmdline_popup = {
      border = {
        style = "none",
        padding = { 2, 3 }
      },
      filter_options = {},
      win_options = {
        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder"
      }
    }
  },
  cmdline = {
    enabled = true,
    inc_rename = false,
    -- view = "cmdline"
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
    -- command_palette = true,
    long_message_to_split = true,
    inc_rename = false,
    -- lsp_doc_border = true
  },
  notify = {
    enabled = false
  },

}
