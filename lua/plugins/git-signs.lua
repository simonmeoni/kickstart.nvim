return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
  },
  config = function(_, opts)
    require('gitsigns').setup {
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, '[G]it Next Hunk')

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, '[G]it Prev Hunk')

        -- Actions
        map('n', '<leader>hs', gitsigns.stage_hunk, '[H]unk [S]tage')
        map('n', '<leader>hr', gitsigns.reset_hunk, '[H]unk [R]eset')

        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, '[H]unk [S]tage (visual)')

        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, '[H]unk [R]eset (visual)')

        map('n', '<leader>hS', gitsigns.stage_buffer, '[H]unk [S]tage [B]uffer')
        map('n', '<leader>hR', gitsigns.reset_buffer, '[H]unk [R]eset [B]uffer')
        map('n', '<leader>hp', gitsigns.preview_hunk, '[H]unk [P]review')
        map('n', '<leader>hi', gitsigns.preview_hunk_inline, '[H]unk [I]nline Preview')

        map('n', '<leader>hb', function()
          gitsigns.blame_line { full = true }
        end, '[H]unk [B]lame Line (full)')

        map('n', '<leader>hd', gitsigns.diffthis, '[H]unk [D]iff This')
        map('n', '<leader>hD', function()
          gitsigns.diffthis '~'
        end, '[H]unk [D]iff Against ~')

        map('n', '<leader>hQ', function()
          gitsigns.setqflist 'all'
        end, '[H]unk [Q]uickfix All')
        map('n', '<leader>hq', gitsigns.setqflist, '[H]unk [Q]uickfix Current')

        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, '[T]oggle [B]lame')
        map('n', '<leader>tw', gitsigns.toggle_word_diff, '[T]oggle [W]ord Diff')

        -- Text object
        map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, '[I]nner [H]unk')
      end,
    }
  end,
}
