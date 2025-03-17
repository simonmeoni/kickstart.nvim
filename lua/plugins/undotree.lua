return {
  'mbbill/undotree',
  config = function()
    vim.cmd [[
      if has("persistent_undo")
        let target_path = expand('~/.undodir')
        if !isdirectory(target_path)
          call mkdir(target_path, "p", 0700)
        endif
        let &undodir = target_path
        set undofile
      endif
      let g:undotree_WindowLayout = 4
      let g:undotree_SetFocusWhenToggle = 1
    ]]
    vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, {})
  end,
}
