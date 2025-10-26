return {
  'sindrets/diffview.nvim',
  dependencies = 'nvim-lua/plenary.nvim',
  opts = {
    keymaps = {
      view = {
        { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close diffview' } },
      },
      file_panel = {
        { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close diffview' } },
      },
    },
  },
  keys = {
    -- Simple diff of current changes vs HEAD
    { '<leader>gD', '<cmd>DiffviewOpen<cr>', desc = 'Diffview: current changes' },

    -- Compare with branch using Snacks picker
    {
      '<leader>gv',
      function()
        Snacks.picker.git_branches {
          confirm = function(picker, item)
            picker:close()
            if item then
              local branch = item.branch or item.text or item
              vim.cmd('DiffviewOpen ' .. branch)
            end
          end,
        }
      end,
      desc = 'Diffview: compare branch',
    },

    -- Compare with commit using Snacks picker
    {
      '<leader>gV',
      function()
        Snacks.picker.git_log {
          confirm = function(picker, item)
            picker:close()
            if item then
              local hash = item.hash or item.commit or item.text
              if hash then
                vim.cmd('DiffviewOpen ' .. hash)
              end
            end
          end,
        }
      end,
      desc = 'Diffview: compare commit',
    },

    -- Merge tool for conflicts
    { '<leader>gm', '<cmd>DiffviewOpen -m<cr>', desc = 'Diffview: merge conflicts' },

    -- File history
    { '<leader>gh', '<cmd>DiffviewFileHistory<cr>', desc = 'Diffview: repo history' },
    { '<leader>gH', '<cmd>DiffviewFileHistory %<cr>', desc = 'Diffview: file history' },

    -- Close diffview
    { '<leader>gq', '<cmd>DiffviewClose<cr>', desc = 'Diffview: close' },
  },
}
