return {
  'ThePrimeagen/refactoring.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  lazy = false,
  opts = {},

  vim.keymap.set('x', '<leader>re', ':refactor extract ', { desc = '[R]efactor [E]xtract' }),
  vim.keymap.set('x', '<leader>rf', ':refactor extract_to_file ', { desc = '[R]efactor Extract to [F]ile' }),
  vim.keymap.set('x', '<leader>rv', ':refactor extract_var ', { desc = '[R]efactor Extract [V]ariable' }),
  vim.keymap.set({ 'n', 'x' }, '<leader>ri', ':refactor inline_var', { desc = '[R]efactor [I]nline Variable' }),
  vim.keymap.set('n', '<leader>ri', ':refactor inline_func', { desc = '[R]efactor Inline [F]unction' }),
  vim.keymap.set('n', '<leader>rb', ':refactor extract_block', { desc = '[R]efactor Extract [B]lock' }),
  vim.keymap.set('n', '<leader>rbf', ':refactor extract_block_to_file', { desc = '[R]efactor Extract [B]lock to [F]ile' }),
}
