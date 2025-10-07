return {
  -- Diff/merge UI
  'sindrets/diffview.nvim',
  dependencies = {
    'folke/snacks.nvim', -- le picker
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('diffview').setup()
  end,
  keys = {
    -- Vues directes Diffview (inchangé)
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = '[G]it [D]iff working tree vs HEAD' },
    { '<leader>gh', '<cmd>DiffviewFileHistory<cr>', desc = '[G]it [H]istory repo commits' },
    { '<leader>gH', '<cmd>DiffviewFileHistory %<cr>', desc = '[G]it [H]istory current file' },

    {
      '<leader>gc',
      function()
        Snacks.picker.git_log {
          confirm = function(picker, item)
            -- Champs possibles selon la source (soyons robustes)
            local hash = item.hash or (item.commit and (item.commit.hash or item.commit.oid)) or item.value or item.text
            picker:close()
            if hash then
              vim.cmd('DiffviewOpen ' .. hash)
            else
              vim.notify('Impossible de récupérer le hash du commit', vim.log.levels.WARN)
            end
          end,
        }
      end,
      desc = '[G]it [C]ommits → Diffview',
    },

    -- Commits du fichier courant → Diffview (equiv. git_bcommits)
    {
      '<leader>gC',
      function()
        local file = vim.fn.expand '%'
        Snacks.picker.git_log_file {
          confirm = function(picker, item)
            local hash = item.hash or (item.commit and (item.commit.hash or item.commit.oid)) or item.value or item.text
            picker:close()
            if hash and file ~= '' then
              -- diff du commit (range ^!) restreint au fichier courant
              vim.cmd('DiffviewOpen ' .. hash .. '^! -- ' .. vim.fn.fnameescape(file))
            end
          end,
        }
      end,
      desc = '[G]it file [C]ommits → Diffview',
    },

    -- Raccourci “voir le diff du commit sélectionné pour CE fichier”
    {
      '<leader>gi',
      function()
        local file = vim.fn.expand '%'
        Snacks.picker.git_log_file {
          confirm = function(picker, item)
            local hash = item.hash or (item.commit and (item.commit.hash or item.commit.oid)) or item.value or item.text
            picker:close()
            if hash and file ~= '' then
              vim.cmd('DiffviewOpen ' .. hash .. ' -- ' .. vim.fn.fnameescape(file))
            end
          end,
        }
      end,
      desc = '[G]it View Commit d[I]ff for current file',
    },
  },
}
