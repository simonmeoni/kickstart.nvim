-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Upload change to Jean-Zay only when I am working on synth-kg
local lunette = {
  rsync_autocmd_enabled = false,
  rsync_autocmd_id = nil,
  source_dir = '/Users/Simon/Code/open-nlp/lib/synth-kg',
  dest_dir = 'ufw96he@jean-zay.idris.fr:/lustre/fswork/projects/rech/lch/ufw96he/lib/synth-kg',
}

function lunette.toggle_rsync_autocmd()
  local current_dir = vim.fn.getcwd()
  if current_dir == lunette.source_dir then
    if lunette.rsync_autocmd_enabled then
      vim.api.nvim_del_autocmd(lunette.rsync_autocmd_id)
      print 'Lunette autocommand disabled'
    else
      lunette.rsync_autocmd_id = vim.api.nvim_create_autocmd('BufWritePost', {
        pattern = '*',
        command = string.format('silent! !rsync -avz --exclude datasets %s/ %s/', lunette.source_dir, lunette.dest_dir),
      })
      print 'Lunette autocommand enabled'
    end
    lunette.rsync_autocmd_enabled = not lunette.rsync_autocmd_enabled
  else
    print 'Lunette autocommand can only be toggled in the source directory'
  end
end

-- Optional: create a user command on load
vim.api.nvim_create_user_command('Lunette', function()
  lunette.toggle_rsync_autocmd()
end, {})

lunette.toggle_rsync_autocmd()
