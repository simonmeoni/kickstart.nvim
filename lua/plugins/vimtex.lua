return {
  'lervag/vimtex',
  lazy = false,
  init = function()
    vim.g.vimtex_view_method = 'skim'
    vim.g.vimtex_view_skim_sync = 1
    vim.g.vimtex_view_skim_activate = 1
    vim.g.vimtex_quickfix_mode = 0
    vim.g.vimtex_log_file_exts = {
      'log',
      'aux',
      'blg',
      'bbl',
      'synctex.gz',
      'fdb_latexmk',
      'fls',
      'out',
      'toc',
      'acn',
      'acr',
      'alg',
      'glg',
      'glo',
      'gls',
    }
  end,
}
