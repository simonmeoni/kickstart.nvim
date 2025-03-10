return {
  'smithbm2316/centerpad.nvim',

  config = function()
    vim.keymap.set('n', '<leader>z', '<cmd>Centerpad<cr>', { desc = 'Center Buffer' })
  end,
}
