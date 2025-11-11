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
    },
    extensions = { 'oil', 'lazy', 'quickfix' },
  },
}
