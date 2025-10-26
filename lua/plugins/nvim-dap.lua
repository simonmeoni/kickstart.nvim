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

    -- History storage for debug/run configurations
    local run_history = {}
    local max_history = 20 -- Maximum number of history entries
    local history_file = vim.fn.getcwd() .. '/.nvim/dap_run_history.json'

    -- Function to load history from file
    local function load_history()
      local file = io.open(history_file, 'r')
      if file then
        local content = file:read('*a')
        file:close()
        local ok, decoded = pcall(vim.json.decode, content)
        if ok and decoded then
          run_history = decoded
        end
      end
    end

    -- Function to save history to file
    local function save_history()
      -- Create .nvim directory if it doesn't exist
      vim.fn.mkdir(vim.fn.getcwd() .. '/.nvim', 'p')
      local file = io.open(history_file, 'w')
      if file then
        file:write(vim.json.encode(run_history))
        file:close()
      end
    end

    -- Load history on startup
    load_history()

    -- Function to add entry to history
    local function add_to_history(entry)
      -- Check if exact same entry exists
      for i, existing in ipairs(run_history) do
        if existing.mode == entry.mode
          and existing.type == entry.type
          and existing.target == entry.target
          and existing.args == entry.args then
          -- Move existing entry to front
          table.remove(run_history, i)
          table.insert(run_history, 1, existing)
          save_history()
          return
        end
      end

      -- Add new entry at the front
      table.insert(run_history, 1, entry)

      -- Trim history if too long
      if #run_history > max_history then
        table.remove(run_history)
      end

      -- Save to disk
      save_history()
    end

    -- Function to select and run from history
    local function run_from_history()
      if #run_history == 0 then
        vim.notify('No run history available', vim.log.levels.WARN)
        return
      end

      local items = {}
      for i, entry in ipairs(run_history) do
        local mode_icon = entry.mode == 'DEBUG' and '🐛' or '▶️'
        local target = entry.type == 'file'
          and vim.fn.fnamemodify(entry.target, ':t')  -- Just filename
          or entry.target  -- Module name as-is

        local label = mode_icon .. ' ' .. target
        if entry.args and entry.args ~= '' then
          label = label .. ' ' .. entry.args
        end
        table.insert(items, label)
      end

      vim.ui.select(items, {
        prompt = 'Select configuration to run:',
        format_item = function(item)
          return item
        end,
      }, function(_, idx)
        if not idx then return end

        local entry = run_history[idx]
        if entry.mode == 'DEBUG' then
          -- Run in debug mode
          if entry.type == 'file' then
            dap.run({
              type = 'python',
              request = 'launch',
              name = 'Launch file',
              program = entry.target,
              args = entry.args ~= '' and vim.split(entry.args, ' +') or {},
              pythonPath = function()
                if vim.env.VIRTUAL_ENV then
                  return vim.env.VIRTUAL_ENV .. '/bin/python'
                end
                return 'python'
              end,
              console = 'integratedTerminal',
            })
          elseif entry.type == 'module' then
            dap.run({
              type = 'python',
              request = 'launch',
              name = 'Launch module',
              module = entry.target,
              args = entry.args ~= '' and vim.split(entry.args, ' +') or {},
              pythonPath = function()
                if vim.env.VIRTUAL_ENV then
                  return vim.env.VIRTUAL_ENV .. '/bin/python'
                end
                return 'python'
              end,
              console = 'integratedTerminal',
            })
          end
        elseif entry.mode == 'RUN' then
          -- Run without debug
          local python = vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. '/bin/python') or 'python'
          local cmd
          if entry.type == 'file' then
            cmd = python .. ' ' .. entry.target
          elseif entry.type == 'module' then
            cmd = python .. ' -m ' .. entry.target
          end
          if entry.args and entry.args ~= '' then
            cmd = cmd .. ' ' .. entry.args
          end
          vim.cmd('botright 25split | terminal ' .. cmd)
        end
      end)
    end

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
      local file = vim.fn.expand '%:p'
      local args = vim.fn.input('Arguments: ', last_file_args)
      last_file_args = args

      -- Save to history
      add_to_history({
        mode = 'DEBUG',
        type = 'file',
        target = file,
        args = args,
      })

      dap.run({
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = file,
        args = args ~= '' and vim.split(args, ' +') or {},
        pythonPath = function()
          if vim.env.VIRTUAL_ENV then
            return vim.env.VIRTUAL_ENV .. '/bin/python'
          end
          return 'python'
        end,
        console = 'integratedTerminal',
      })
    end, { desc = 'DAP: Launch current file' })

    -- <Leader>cC : Debug module avec args
    vim.keymap.set('n', '<Leader>cC', function()
      local module = vim.fn.input('Module name: ', last_module)
      if module ~= '' then
        last_module = module
      end
      local args = vim.fn.input('Arguments: ', last_module_args)
      last_module_args = args

      -- Save to history
      add_to_history({
        mode = 'DEBUG',
        type = 'module',
        target = module,
        args = args,
      })

      dap.run({
        type = 'python',
        request = 'launch',
        name = 'Launch module',
        module = module,
        args = args ~= '' and vim.split(args, ' +') or {},
        pythonPath = function()
          if vim.env.VIRTUAL_ENV then
            return vim.env.VIRTUAL_ENV .. '/bin/python'
          end
          return 'python'
        end,
        console = 'integratedTerminal',
      })
    end, { desc = 'DAP: Launch module' })

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

      -- Save to history
      add_to_history({
        mode = 'RUN',
        type = 'file',
        target = file,
        args = args,
      })

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

      -- Save to history
      add_to_history({
        mode = 'RUN',
        type = 'module',
        target = module,
        args = args,
      })

      local python = vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. '/bin/python') or 'python'
      local cmd = python .. ' -m ' .. module
      if args ~= '' then
        cmd = cmd .. ' ' .. args
      end

      -- Ouvre un terminal nvim en bas (25 lignes)
      vim.cmd('botright 25split | terminal ' .. cmd)
    end, { desc = 'Run Python module in terminal' })

    -- <Leader>ch : Select from run/debug history
    vim.keymap.set('n', '<Leader>ch', run_from_history, { desc = 'Select from run/debug history' })

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
