return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    cmdline = {
      enabled = true,
      view = 'cmdline_popup',
      format = {
        cmdline = { icon = '>' },
        search_down = { icon = '🔍⌄' },
        search_up = { icon = '🔍⌃' },
      },
    },
    lsp = {
      progress = { enabled = true },
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = false,
      },
    },
    messages = {
      enabled = true,
      view = 'notify',
    },
    notify = {
      enabled = false,
    },
    popupmenu = {
      enabled = false,
    },
    presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = true,
    },
    routes = {
      {
        filter = {
          event = 'msg_show',
          any = {
            { find = '%d+L, %d+B' },
            { find = '; after #%d+' },
            { find = '; before #%d+' },
          },
        },
        opts = { skip = true },
      },
    },
  },
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
}
