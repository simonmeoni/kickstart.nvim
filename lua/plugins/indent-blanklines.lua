return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  opts = {
    exclude = {
      filetypes = {
        'help',
        'startify',
        'aerial',
        'alpha',
        'dashboard',
        'packer',
        'neogitstatus',
        'nvimtree',
        'neo-tree',
        'trouble',
      },
    },
    indent = {
      highlight = highlight,
      char = '',
    },
    whitespace = {
      highlight = { 'cursorcolumn', 'whitespace' },
      remove_blankline_trail = false,
    },
    scope = {
      enabled = false,
    },
  },
}
