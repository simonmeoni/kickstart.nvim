return {
  'ruifm/gitlinker.nvim',
  dependencies = 'nvim-lua/plenary.nvim',
  config = function()
    require('gitlinker').setup {
      opts = {
        remote = nil, -- auto-detect remote
        add_current_line_on_normal_mode = true,
        action_callback = require('gitlinker.actions').copy_to_clipboard,
        print_url = true,
      },
      callbacks = {
        ['github.com'] = require('gitlinker.hosts').get_github_type_url,
        ['gitlab.com'] = require('gitlinker.hosts').get_gitlab_type_url,
        ['bitbucket.org'] = require('gitlinker.hosts').get_bitbucket_type_url,
      },
      mappings = nil, -- disable default mappings, we define our own below
    }
  end,
  keys = {
    -- Copy git link to clipboard
    {
      '<leader>gy',
      '<cmd>lua require"gitlinker".get_buf_range_url("n")<cr>',
      mode = 'n',
      desc = 'Git: copy link',
    },
    {
      '<leader>gy',
      '<cmd>lua require"gitlinker".get_buf_range_url("v")<cr>',
      mode = 'v',
      desc = 'Git: copy link (range)',
    },

    -- Open git link in browser
    {
      '<leader>gb',
      '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
      mode = 'n',
      desc = 'Git: open in browser',
    },
    {
      '<leader>gb',
      '<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
      mode = 'v',
      desc = 'Git: open in browser (range)',
    },

    -- Get repository URL
    {
      '<leader>gY',
      '<cmd>lua require"gitlinker".get_repo_url()<cr>',
      mode = 'n',
      desc = 'Git: copy repo URL',
    },
  },
}
