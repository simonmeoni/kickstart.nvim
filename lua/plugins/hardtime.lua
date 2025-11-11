return {
  'm4xshen/hardtime.nvim',
  lazy = false,
  dependencies = { 'MunifTanjim/nui.nvim' },
  opts = {
    max_count = 4, -- Allow 4 repetitions before warning (default is 2)
    disable_mouse = false, -- Don't disable mouse
    hint = true, -- Show hints instead of just blocking
    notification = true, -- Show notifications
    allow_different_key = true, -- Reset count if different key is pressed
    enabled = true,
    restriction_mode = 'hint', -- 'block' or 'hint' - use hint to be less aggressive
    disabled_filetypes = {
      'qf',
      'netrw',
      'lazy',
      'mason',
      'oil',
      'snacks_explorer',
    },
  },
}
