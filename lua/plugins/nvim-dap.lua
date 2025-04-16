return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio', -- required by dap-ui
    'theHamsta/nvim-dap-virtual-text',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('nvim-dap-virtual-text').setup()
    dapui.setup()

    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end

    -- Python adapter
    dap.adapters.python = {
      type = 'executable',
      command = 'python',
      args = { '-m', 'debugpy.adapter' },
    }

    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        pythonPath = function()
          return 'python'
        end,
      },
    }

    -- Keymaps
    vim.keymap.set('n', '<Leader>cc', function()
      dap.continue()
    end, { desc = 'DAP: Continue' })
    vim.keymap.set('n', '<Leader>co', function()
      dap.step_over()
    end, { desc = 'DAP: Step Over' })
    vim.keymap.set('n', '<Leader>ci', function()
      dap.step_into()
    end, { desc = 'DAP: Step Into' })
    vim.keymap.set('n', '<Leader>cu', function()
      dap.step_out()
    end, { desc = 'DAP: Step Out' })
    vim.keymap.set('n', '<Leader>cb', function()
      dap.toggle_breakpoint()
    end, { desc = 'DAP: Toggle Breakpoint' })
    vim.keymap.set('n', '<Leader>cB', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'DAP: Set Conditional Breakpoint' })
  end,
}
