return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  config = function()
    vim.opt.background = 'light' -- optional
    require('catppuccin').setup {
      flavour = 'latte', -- light flavor
      integrations = {
        cmp = true,
        gitsigns = true,
        treesitter = true,
        nvimtree = true,
        mason = true,
        lsp_trouble = true,
      },
    }
    vim.cmd.colorscheme 'catppuccin'
  end,
}
