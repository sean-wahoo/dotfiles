local ok, noice = pcall(require, "noice")
if not ok then
  vim.notify("noice failed to load")
  return
end

noice.setup({
  views = {
    cmdline_popup = {
      border = {
        padding = { 2, 3 },
      },
      filter_options = {},
      win_options = {
        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
      },
    },
  },
  popupmenu = {
    enabled = true,
  },
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
    hover = { enabled = true },
    documentation = {
      view = "hover",
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
    lsp_doc_border = true,
  },
  health = {
    checker = true,
  },
})

local notify_ok, notify = pcall(require, "notify")
if not notify_ok then
  print("notify oopsie!")
  return
end
notify.setup({
  background_colour = "#000000",
  timeout = 3000,
  render = "compact",
})
