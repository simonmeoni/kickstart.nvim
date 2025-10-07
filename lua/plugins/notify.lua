return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    lsp = {
      progress = { enabled = true },
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
    },
    messages = {
      enabled = true,
      view = 'mini',
      view_warn = 'mini',
      view_error = 'mini',
    },
    presets = {
      long_message_to_split = true,
    },
    views = {
      mini = {
        position = {
          row = 0, -- tout en haut
          col = '100%', -- à droite
        },
        align = 'right', -- aligne le texte à droite
      },
    },
  },
  dependencies = {
    'MunifTanjim/nui.nvim', -- requis !
  },
}
