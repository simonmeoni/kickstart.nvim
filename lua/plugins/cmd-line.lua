return {
  {
    'VonHeikemen/fine-cmdline.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
  },
  vim.api.nvim_set_keymap('n', ':', '<cmd>FineCmdline<CR>', { noremap = true }),
}
