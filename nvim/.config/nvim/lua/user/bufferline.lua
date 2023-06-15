local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
  print("bufferline couldn't be loaded!")
  return
end

bufferline.setup {
  options = {
    mode = "buffers",
    numbers = "ordinal",
    indicator = {
      style = 'icon',
      icon = '|'
    },
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = true,
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        text_align = "left",
        separator = true
      }
    },
    color_icons = true,
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    get_element_icon = function (element)
      -- return require('nvim-web-devicons').get_icon(element.name, { default = true })
      return require('nvim-web-devicons').get_icon(element.name, { default = false })
    end,
    show_close_icon = true,
    show_tab_indicators = true,
    separator_style = "thin",
    always_show_bufferline = true,
    hover = {
      enabled = true,
      delay = 50,
      reveal = { 'close' }
    },
    diagnostics_indicator = function(count, level)
      local icon = level:match("error") and " " or ""
      return " " .. icon .. count
    end
  }
}
