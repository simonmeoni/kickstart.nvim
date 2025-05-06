return {
  'nvim-pack/nvim-spectre',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    replace_engine = {
      ['sd'] = {
        cmd = 'sd',
        options = {},
      },
    },
    default = {
      replace = {
        cmd = 'sd',
      },
    },
  },
  config = function()
    vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
      desc = '[S]pectre Toggle',
    })
    vim.keymap.set('v', '<leader>Sv', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
      desc = '[S]earch current word ([V]isual)',
    })
  end,
}
