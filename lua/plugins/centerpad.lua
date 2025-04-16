return {
  'smithbm2316/centerpad.nvim',

  config = function()
    vim.keymap.set('n', '<leader>z', '<cmd>Centerpad<cr>', { desc = '[Z] Center Buffer' })
  end,
}
