return {
  'ThePrimeagen/refactoring.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  lazy = false,
  opts = {},

  vim.keymap.set('x', '<leader>re', ':Refactor extract ', { desc = '[R]efactor [E]xtract' }),
  vim.keymap.set('x', '<leader>rf', ':Refactor extract_to_file ', { desc = '[R]efactor Extract to [F]ile' }),
  vim.keymap.set('x', '<leader>rv', ':Refactor extract_var ', { desc = '[R]efactor Extract [V]ariable' }),
  vim.keymap.set({ 'n', 'x' }, '<leader>ri', ':Refactor inline_var', { desc = '[R]efactor [I]nline Variable' }),
  vim.keymap.set('n', '<leader>ri', ':Refactor inline_func', { desc = '[R]efactor Inline [F]unction' }),
  vim.keymap.set('n', '<leader>rb', ':Refactor extract_block', { desc = '[R]efactor Extract [B]lock' }),
  vim.keymap.set('n', '<leader>rbf', ':Refactor extract_block_to_file', { desc = '[R]efactor Extract [B]lock to [F]ile' }),
}
