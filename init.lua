-- Set <space> as the leader key
--  NOTE: Must happen before plugins are loaded
--  (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.o.termguicolors = true

require 'options'
require 'keymaps'
require 'lazy-bootstrap'
require 'autocommands'
require 'health'

-- [[ Configure and install plugins ]]

require('lazy').setup {
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  require 'plugins/which-key',
  require 'plugins/git-signs',
  require 'plugins/snack',
  require 'plugins/hardtime',
  require 'plugins/lazy-dev',
  require 'plugins/nvim-lspconfig',
  require 'plugins/trouble',
  require 'plugins/indent-blanklines',
  require 'plugins/conform',
  require 'plugins/nvim-cmp',
  require 'plugins/catpuccin',
  require 'plugins/todo-comments',
  require 'plugins/mini',
  require 'plugins/smartcolumn',
  require 'plugins/oil',
  require 'plugins/harpoon',
  require 'plugins/yankstack',
  require 'plugins/nvim-webdev-icons',
  require 'plugins/lazygit',
  require 'plugins/lint',
  require 'plugins/nvim-dap',
  require 'plugins/refactor',
  require 'plugins/fortune',
  require 'plugins/notify',
  require 'plugins/treesitter',
  require 'plugins/dashboard-nvim',
  require 'plugins/molten',
  require 'plugins/autopairs',
  require 'plugins/spectre',
  require 'plugins/copilot',
  require 'plugins/nvim-tmux-navigation',
  require 'plugins/diffview',
  require 'plugins/vimtex',
  require 'plugins/neoscroll',
  require 'plugins/eldritch',
  require 'plugins/github-monochrome',
  require 'plugins/sidekick',
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
