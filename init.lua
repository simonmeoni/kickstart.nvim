-- Set <space> as the leader key
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)

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
  require 'plugins/telescope',
  require 'plugins/hardtime',
  require 'plugins/lazy-dev',
  require 'plugins/nvim-lspconfig',
  require 'plugins/indent-blanklines',
  require 'plugins/venv-selector',
  require 'plugins/conform',
  require 'plugins/nvim-cmp',
  require 'plugins/catpuccin',
  require 'plugins/todo-comments',
  require 'plugins/centerpad',
  require 'plugins/mini',
  require 'plugins/oil',
  require 'plugins/virt-column',
  require 'plugins/harpoon',
  require 'plugins/yankstack',
  require 'plugins/nvim-webdev-icons',
  require 'plugins/lazygit',
  require 'plugins/lint',
  require 'plugins/cmd-line',
  require 'plugins/undotree',
  require 'plugins/nvim-dap',
  require 'plugins/refactor',
  require 'plugins/fortune',
  require 'plugins/notify',
  require 'plugins/treesitter',
  require 'plugins/dashboard-nvim',
  require 'plugins/molten',
  require 'plugins/autopairs',
  require 'plugins/spectre',
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
