-- Set <space> as the leader key
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

require 'options'
require 'keymaps'
require 'lazy-bootstrap'

-- [[ Configure and install plugins ]]

require('lazy').setup {
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  require 'plugins/which-key',
  require 'plugins/git-signs',
  require 'plugins/telescope',
  require 'plugins/lazy-dev',
  require 'plugins/nvim-lspconfig',
  require 'plugins/indent-blanklines',
  require 'plugins/venv-selector',
  require 'plugins/conform',
  require 'plugins/nvim-cmp',
  require 'plugins/oxocarbon',
  require 'plugins/todo-comments',
  require 'plugins/centerpad',
  require 'plugins/mini',
  require 'plugins/autosave',
  require 'plugins/oil',
  require 'plugins/harpoon',
  require 'plugins/yankstack',
  require 'plugins/nvim-webdev-icons',
  require 'plugins/lazygit',
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
