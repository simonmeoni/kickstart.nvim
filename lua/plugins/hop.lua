return {
  'phaazon/hop.nvim',
  config = function()
    require('hop').setup()
    local hop = require 'hop'
    local directions = require('hop.hint').HintDirection
    vim.keymap.set('', 'f', function()
      hop.hint_words { direction = directions.AFTER_CURSOR, current_line_only = true }
    end, { remap = true })
    vim.keymap.set('', 'F', function()
      hop.hint_words { direction = directions.BEFORE_CURSOR, current_line_only = true }
    end, { remap = true })
    vim.keymap.set('', 't', function()
      hop.hint_words { direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 }
    end, { remap = true })
    vim.keymap.set('', 'T', function()
      hop.hint_words { direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 }
    end, { remap = true })
    vim.keymap.set('', 's', function()
      hop.hint_words { current_line_only = false, hint_offset = 1 }
    end, { remap = true })
  end,
}
