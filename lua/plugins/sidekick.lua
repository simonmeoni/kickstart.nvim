return {
  'simonmeoni/dummy-sidekick',
  dependencies = { 'nvim-lua/plenary.nvim' }, -- For testing
  config = function()
    require('sidekick').setup {
      search_patterns = { 'claude', 'node' },
      notify_on_reload = true,
      auto_reload = {
        enabled = true,
        updatetime = 25,
      },
      keymaps = {
        enabled = true,
        select_pane = '<leader>kc',
        add_buffer = '<leader>kb',
        send_selection = '<leader>ks',
      },
    }
  end,
}
