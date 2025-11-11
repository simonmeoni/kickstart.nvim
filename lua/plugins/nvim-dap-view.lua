return {
  {
    'igorlfs/nvim-dap-view',
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    ft = { 'dap-repl' },
    lazy = false, -- Load immediately so listeners are registered
    ---@module 'dap-view'
    ---@type dapview.Config
    opts = {
      auto_toggle = true,
      windows = {
        height = 0.3,
        position = 'below',
        terminal = {
          start_hidden = false,
          width = 0.5,
          position = 'left',
        },
      },
      winbar = {
        sections = { 'watches', 'scopes', 'breakpoints', 'repl', 'console' },
        default_section = 'scopes',
      },
    },
    config = function(_, opts)
      require('dap-view').setup(opts)
    end,
    keys = {
      { '<leader>cv', '<cmd>DapViewToggle<cr>', desc = 'DAP: Toggle view' },
    },
  },
}
