return {
  'ThePrimeagen/harpoon',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('harpoon').setup {
      global_settings = {
        save_on_toggle = false,
        save_on_change = true,
        enter_on_sendcmd = false,
        tmux_autoclose_windows = false,
        excluded_filetypes = { 'harpoon' },
        mark_branch = false,
      },
    }
    local harpoon_mark = require 'harpoon.mark'
    local harpoon_ui = require 'harpoon.ui'

    vim.keymap.set('n', '<leader>aa', harpoon_mark.add_file, { desc = 'Add file to Harpoon' })
    vim.keymap.set('n', '<leader>ah', harpoon_ui.toggle_quick_menu, { desc = 'Toggle Harpoon menu' })
  end,
}
