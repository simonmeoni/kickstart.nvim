-- Trouble.nvim - Better diagnostics list
--
-- PERSISTENT TROUBLE OPTIONS:
-- 1. Use `<leader>xp` to toggle a pinned diagnostics window (bound to current buffer)
-- 2. Set `auto_close = false` in opts to prevent closing when empty
-- 3. Set `restore = true` to restore last location when reopening
-- 4. Use multiple trouble windows via API: require('trouble').open({ mode = '...' })
--
-- SNACKS INTEGRATION:
-- - From any snacks picker, use `<C-t>` to send results to trouble
-- - Picker actions: trouble_open, trouble_open_selected, trouble_open_all
--
return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    auto_close = false, -- auto close when there are no items
    auto_open = false, -- auto open when there are items
    auto_preview = false, -- automatically open preview when on an item
    auto_refresh = false, -- auto refresh when open
    auto_jump = false, -- auto jump to the item when there's only one
    focus = false, -- Focus the window when opened
    restore = true, -- restores the last location in the list when opening
    follow = false, -- Follow the current item
    indent_guides = true, -- show indent guides
    max_items = 200, -- limit number of items that can be displayed per section
    multiline = true, -- render multi-line messages
    pinned = false, -- When pinned, the opened trouble window will be bound to the current buffer
    warn_no_results = true, -- show a warning when there are no results
    open_no_results = false, -- open the trouble window when there are no results
    win = {}, -- window options for the results window. Can be a split or a floating window.
    preview = {
      type = 'main', -- show preview in main window
      scratch = true,
    },
    modes = {
      diagnostics = {
        auto_open = false,
      },
      lsp = {
        win = { position = 'right' },
      },
      -- Snacks integration
      snacks = {
        desc = 'Snacks results previously opened',
        mode = 'snacks',
        auto_open = false,
      },
      snacks_files = {
        desc = 'Snacks file results',
        mode = 'snacks_files',
        auto_open = false,
      },
    },
  },
  cmd = 'Trouble',
  keys = {
    -- Trouble main toggles
    {
      '<leader>xx',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = 'Diagnostics (Trouble)',
    },
    {
      '<leader>xp',
      '<cmd>Trouble diagnostics toggle pinned=true<cr>',
      desc = 'Pinned Diagnostics (Trouble)',
    },
    {
      '<leader>xX',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      desc = 'Buffer Diagnostics (Trouble)',
    },
    {
      '<leader>xs',
      '<cmd>Trouble symbols toggle focus=false<cr>',
      desc = 'Symbols (Trouble)',
    },
    {
      '<leader>xl',
      '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
      desc = 'LSP Definitions / references / ... (Trouble)',
    },
    {
      '<leader>xL',
      '<cmd>Trouble loclist toggle<cr>',
      desc = 'Location List (Trouble)',
    },
    {
      '<leader>xQ',
      '<cmd>Trouble qflist toggle<cr>',
      desc = 'Quickfix List (Trouble)',
    },
    -- Replace diagnostic keybindings
    {
      '<leader>q',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = 'Diagnostics (Trouble)',
    },
    {
      '<leader>cn',
      function()
        if require('trouble').is_open() then
          require('trouble').next { skip_groups = true, jump = true }
        else
          local ok, err = pcall(vim.cmd.cnext)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = 'Next Trouble/Quickfix Item',
    },
    {
      '<leader>cp',
      function()
        if require('trouble').is_open() then
          require('trouble').prev { skip_groups = true, jump = true }
        else
          local ok, err = pcall(vim.cmd.cprev)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = 'Previous Trouble/Quickfix Item',
    },
  },
}
