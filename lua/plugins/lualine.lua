return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      theme = 'auto',
      globalstatus = true,
      component_separators = '|',
      section_separators = '',
    },
    sections = {
      lualine_c = { { 'filename', path = 1 } },
      lualine_x = {
        -- Lightweight diagnostic count using built-in lualine component
        {
          'diagnostics',
          sources = { 'nvim_diagnostic' },
          sections = { 'error', 'warn' },
          symbols = { error = '󰅚 ', warn = '󰀪 ' },
          colored = true,
          update_in_insert = false,
          always_visible = false,
        },
        'encoding',
        'fileformat',
        'filetype',
      },
    },
    extensions = { 'oil', 'lazy', 'quickfix', 'trouble' },
  },
}
