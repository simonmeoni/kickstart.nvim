return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  lazy = false,
  config = function()
    local harpoon = require 'harpoon'
    harpoon:setup()

    vim.keymap.set('n', '<leader>aa', function()
      harpoon:list():add()
    end, { desc = '🔱 Add file' })

    vim.keymap.set('n', '<leader>am', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = '🔱 Menu' })

    vim.keymap.set('n', '<leader>ap', function()
      harpoon:list():prev()
    end, { desc = '🔱 Previous' })

    vim.keymap.set('n', '<leader>an', function()
      harpoon:list():next()
    end, { desc = '🔱 Next' })
  end,
}
