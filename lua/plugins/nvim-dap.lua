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
      automatic_installation = true,
      handlers = {},
    }

    -- Setup plugins
    dapvt.setup()
    dapui.setup {
      icons = { expanded = '', collapsed = '', current_frame = '' },
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
            { id = 'repl', size = 0.5 },
            { id = 'console', size = 0.5 },
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

    -- Variables pour mémoriser les dernières valeurs
    local last_module = ''
    local last_module_args = ''
    local last_file_args = ''

    dap.configurations.python = {
      -- Fichier actuel avec args mémorisés
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        args = function()
          local args_string = vim.fn.input('Arguments: ', last_file_args)
          last_file_args = args_string
          if args_string == '' then
            return {}
          end
          return vim.split(args_string, ' +')
        end,
        pythonPath = function()
          if vim.env.VIRTUAL_ENV then
            return vim.env.VIRTUAL_ENV .. '/bin/python'
          end
          return 'python'
        end,
        console = 'integratedTerminal',
      },
      -- Module avec mémoire
      {
        type = 'python',
        request = 'launch',
        name = 'Launch module',
        module = function()
          local input = vim.fn.input('Module name: ', last_module)
          if input ~= '' then
            last_module = input
          end
          return last_module
        end,
        args = function()
          local args_string = vim.fn.input('Arguments: ', last_module_args)
          last_module_args = args_string
          if args_string == '' then
            return {}
          end
          return vim.split(args_string, ' +')
        end,
        pythonPath = function()
          if vim.env.VIRTUAL_ENV then
            return vim.env.VIRTUAL_ENV .. '/bin/python'
          end
          return 'python'
        end,
        console = 'integratedTerminal',
      },
    }

    vim.api.nvim_create_autocmd('BufEnter', {
      callback = function()
        if vim.bo.filetype == 'dap-repl' then
          vim.opt_local.signcolumn = 'yes'
          vim.opt_local.wrap = true
          vim.opt_local.linebreak = true
          vim.opt_local.breakindent = true
          vim.opt_local.spell = false
          vim.cmd 'syntax enable'
        end
      end,
    })

    -- Breakpoint visuel
    vim.fn.sign_define('DapBreakpoint', { text = '💀', texthl = 'Error', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped', {
      text = '▶',
      texthl = 'WarningMsg',
      linehl = 'Visual',
      numhl = 'ErrorMsg',
    })

    -- Keymaps DEBUG
    -- <Leader>cc : Lance directement le fichier actuel en debug (demande les args)
    vim.keymap.set('n', '<Leader>cc', function()
      dap.run(dap.configurations.python[1])
    end, { desc = 'DAP: Launch current file' })

    -- <Leader>cC : Ouvre le menu pour choisir entre file/module en debug
    vim.keymap.set('n', '<Leader>cC', dap.continue, { desc = 'DAP: Choose config & Continue' })

    vim.keymap.set('n', '<Leader>co', dap.step_over, { desc = 'DAP: Step Over' })
    vim.keymap.set('n', '<Leader>ci', dap.step_into, { desc = 'DAP: Step Into' })
    vim.keymap.set('n', '<Leader>cu', dap.step_out, { desc = 'DAP: Step Out' })
    vim.keymap.set('n', '<Leader>cq', dap.terminate, { desc = 'DAP: Stop' })
    vim.keymap.set('n', '<Leader>cb', dap.toggle_breakpoint, { desc = 'DAP: Toggle Breakpoint' })
    vim.keymap.set('n', '<Leader>cB', function()
      dap.set_breakpoint(vim.fn.input 'Condition: ')
    end, { desc = 'DAP: Conditional Breakpoint' })

    -- Keymaps RUN (sans debug)
    -- <Leader>cr : Run fichier actuel sans debug (avec args mémorisés)
    -- <Leader>cr : Run fichier actuel sans debug dans un terminal nvim
    vim.keymap.set('n', '<Leader>cr', function()
      local file = vim.fn.expand '%:p'
      local args = vim.fn.input('Arguments: ', last_file_args)
      last_file_args = args

      local python = vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. '/bin/python') or 'python'
      local cmd = python .. ' ' .. file
      if args ~= '' then
        cmd = cmd .. ' ' .. args
      end

      -- Ouvre un terminal nvim en bas (10 lignes)
      vim.cmd('botright 25split | terminal ' .. cmd)
    end, { desc = 'Run Python file in terminal' })

    -- <Leader>cR : Run module sans debug dans un terminal nvim
    vim.keymap.set('n', '<Leader>cR', function()
      local module = vim.fn.input('Module name: ', last_module)
      if module ~= '' then
        last_module = module
      end
      local args = vim.fn.input('Arguments: ', last_module_args)
      last_module_args = args

      local python = vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. '/bin/python') or 'python'
      local cmd = python .. ' -m ' .. module
      if args ~= '' then
        cmd = cmd .. ' ' .. args
      end

      -- Ouvre un terminal nvim en bas (25 lignes)
      vim.cmd('botright 25split | terminal ' .. cmd)
    end, { desc = 'Run Python module in terminal' })
    -- <Leader>cQ : Stop le processus en cours dans le terminal
    vim.keymap.set('n', '<Leader>cQ', function()
      -- Envoie Ctrl+C au terminal
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-\\><C-n>i<C-c>', true, false, true), 'n', false)
    end, { desc = 'Stop running process' })

    -- Alternative : fermer directement le terminal
    vim.keymap.set('n', '<Leader>cX', function()
      -- Trouve et ferme le buffer terminal
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_option(buf, 'buftype') == 'terminal' then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end
    end, { desc = 'Close all terminals' })
  end,
}
