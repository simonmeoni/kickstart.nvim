return {
  'mbbill/undotree',
  config = function()
    vim.cmd [[
      let g:undotree_WindowLayout = 3
      let g:undotree_DiffpanelHeight = 10
      if has("persistent_undo")
        let target_path = expand('~/.undodir')
        if !isdirectory(target_path)
          call mkdir(target_path, "p", 0700)
        endif
        let &undodir = target_path
        set undofile
      endif
    ]]
    vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, {})
  end,
}
