return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'theHamsta/nvim-dap-virtual-text',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    local dapvt = require 'nvim-dap-virtual-text'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},
    }

    -- Setup plugins
    dapvt.setup()

    dapui.setup {
      icons = { expanded = '', collapsed = '', current_frame = '' }, -- No icons
      layouts = {
        {
          elements = {
            { id = 'scopes', size = 0.4 },
            { id = 'breakpoints', size = 0.2 },
            { id = 'stacks', size = 0.2 },
            { id = 'watches', size = 0.2 },
          },
          size = 40,
          position = 'left',
        },
        {
          elements = {
            { id = 'repl', size = 1.0 },
          },
          size = 0.4,
          position = 'bottom',
        },
      },
      controls = {
        enabled = false,
      },
      floating = {
        border = 'rounded',
        mappings = {
          close = { 'q', '<Esc>' },
        },
      },
    }
    -- Auto open/close DAP UI
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end

    -- Adapter Python
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

    vim.api.nvim_create_autocmd('BufEnter', {
      callback = function()
        if vim.bo.filetype == 'dap-repl' then
          vim.opt_local.signcolumn = 'yes'
          vim.opt_local.wrap = true -- 🔁 active le wrapping
          vim.opt_local.linebreak = true -- ✅ wrap propre sur les mots
          vim.opt_local.breakindent = true
          vim.opt_local.spell = false
          vim.cmd 'syntax enable'
        end
      end,
    })
    -- 🧠 Breakpoint visuel : skull
    vim.fn.sign_define('DapBreakpoint', { text = '💀', texthl = 'Error', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped', {
      text = '▶', -- ou '👉' ou '🟥' ou ce que tu veux
      texthl = 'WarningMsg',
      linehl = 'Visual', -- change la ligne entière, genre en surbrillance
      numhl = 'ErrorMsg', -- couleur du numéro de ligne
    })
    -- Keymaps
    vim.keymap.set('n', '<Leader>cc', dap.continue, { desc = 'DAP: Continue' })
    vim.keymap.set('n', '<Leader>co', dap.step_over, { desc = 'DAP: Step Over' })
    vim.keymap.set('n', '<Leader>ci', dap.step_into, { desc = 'DAP: Step Into' })
    vim.keymap.set('n', '<Leader>cu', dap.step_out, { desc = 'DAP: Step Out' })
    vim.keymap.set('n', '<Leader>cb', dap.toggle_breakpoint, { desc = 'DAP: Toggle Breakpoint' })
    vim.keymap.set('n', '<Leader>cB', function()
      dap.set_breakpoint(vim.fn.input 'Condition: ')
    end, { desc = 'DAP: Conditional Breakpoint' })
  end,
}
