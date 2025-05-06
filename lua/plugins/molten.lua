return {
  'benlubas/molten-nvim',
  build = ':UpdateRemotePlugins',
  init = function()
    vim.g.molten_image_provider = 'none' -- ou "none" si t’as pas kitty/ueberzug
    vim.g.molten_auto_open_output = true
  end,
  config = function()
    vim.keymap.set('n', '<leader>mi', '<cmd>MoltenInit<cr>', { desc = '[M]olten: [I]nit kernel' })
    vim.keymap.set('n', '<leader>ml', '<cmd>MoltenEvaluateLine<cr>', { desc = '[M]olten: Eval [L]ine' })
    vim.keymap.set('v', '<leader>mv', ':<C-u>MoltenEvaluateVisual<cr>', { desc = '[M]olten: E[V]al selection' })
    vim.keymap.set('n', '<leader>mc', '<cmd>MoltenEvaluateOperator<cr>', { desc = '[M][C]olten: Eval operator' })
    vim.keymap.set('n', '<leader>md', '<cmd>MoltenDelete<cr>', { desc = '[M]olten: [D]elete output' })
    vim.keymap.set('n', '<leader>mo', '<cmd>MoltenShowOutput<cr>', { desc = '[M]olten: Show last [O]utput' })
    vim.keymap.set('n', '<localleader>md', ':MoltenDelete<CR>', { silent = true, desc = '[M]olten [D]elete cell' })
    vim.keymap.set('n', '<localleader>mh', ':MoltenHideOutput<CR>', { silent = true, desc = '[M]olten: [H]ide output' })
    vim.keymap.set('n', '<localleader>me', ':noautocmd MoltenEnterOutput<CR>', { silent = true, desc = '[M]olten: [E]nter output' })
  end,
}
