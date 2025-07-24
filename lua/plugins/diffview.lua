return { -- Git diff and merge tool
  'sindrets/diffview.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require('diffview').setup()
  end,
  keys = {
    -- Git diff views
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = '[G]it [D]iff working tree vs HEAD' },
    { '<leader>gh', '<cmd>DiffviewFileHistory<cr>', desc = '[G]it [H]istory repo commits' },
    { '<leader>gH', '<cmd>DiffviewFileHistory %<cr>', desc = '[G]it [H]istory current file' },

    -- Telescope commit picker that pipes to diffview
    {
      '<leader>gc',
      function()
        require('telescope.builtin').git_commits {
          attach_mappings = function(_, map)
            local actions = require 'telescope.actions'
            local state = require 'telescope.actions.state'
            map('i', '<CR>', function(prompt_bufnr)
              local entry = state.get_selected_entry()
              actions.close(prompt_bufnr)
              vim.cmd('DiffviewOpen ' .. entry.value)
            end)
            return true
          end,
        }
      end,
      desc = '[G]it [C]ommits → Diffview',
    },

    {
      '<leader>gC',
      function()
        require('telescope.builtin').git_bcommits {
          attach_mappings = function(_, map)
            local actions = require 'telescope.actions'
            local state = require 'telescope.actions.state'
            map('i', '<CR>', function(prompt_bufnr)
              local entry = state.get_selected_entry()
              actions.close(prompt_bufnr)
              vim.cmd('DiffviewOpen ' .. entry.value .. '^!' .. ' -- ' .. vim.fn.expand '%')
            end)
            return true
          end,
        }
      end,
      desc = '[G]it file [C]ommits → Diffview',
    },
    vim.keymap.set('n', '<leader>gvc', function()
      require('telescope.builtin').git_bcommits {
        attach_mappings = function(_, map)
          local actions = require 'telescope.actions'
          local state = require 'telescope.actions.state'

          map('i', '<CR>', function(prompt_bufnr)
            local entry = state.get_selected_entry()
            local commit = entry.value
            local file = vim.fn.expand '%'

            actions.close(prompt_bufnr)
            require 'diffview'
            -- Ouvre le diff entre le fichier courant et le commit sélectionné
            vim.cmd('DiffviewOpen ' .. commit .. ' -- ' .. file)
          end)

          return true
        end,
      }
    end, { desc = '[G]it [V]iew [C]ommit diff for current file' }),
  },
}
