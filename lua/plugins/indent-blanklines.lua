return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  ---@type ibl.config
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
        'NvimTree',
        'neo-tree',
        'Trouble',
      },
    },
  },
}
