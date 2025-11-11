return {
  'piersolenski/import.nvim',
  dependencies = {
    'folke/snacks.nvim',
  },
  opts = {
    picker = 'snacks',
  },
  keys = {
    {
      '<leader>si',
      function()
        require('import').pick()
      end,
      desc = 'Import: Pick import statement',
    },
  },
}
