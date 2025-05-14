-- [[ basic autocommands ]]
--  see `:help lua-guide-autocommands`

-- highlight when yanking (copying) text
--  try it with `yap` in normal mode
--  see `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('textyankpost', {
  desc = 'highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local lunette = {
  rsync_autocmd_id = nil,
  source_dir = '/Users/Simon/Code/open-nlp/lib/self-dp-instruct',
  dest_host = 'ufw96he@jean-zay.idris.fr',
  dest_dir = '/lustre/fswork/projects/rech/lch/ufw96he/lib/self-dp-instruct',
}

function lunette.toggle_rsync_autocmd()
  local cwd = vim.fn.getcwd()
  if cwd == lunette.source_dir then
    print 'Lunette autocommand is toggled !'
    lunette.rsync_autocmd_id = vim.api.nvim_create_autocmd('BufWritePost', {
      pattern = '*',
      callback = function(ctx)
        local abs = ctx.file
        local rel = vim.fn.fnamemodify(abs, ':.')
        local dst = string.format('%s/%s', lunette.dest_dir, rel)
        -- création du dossier distant si besoin
        vim.fn.system {
          'ssh',
          lunette.dest_host,
          'mkdir -p ' .. vim.fn.fnamemodify(dst, ':h'),
        }
        -- envoi du fichier
        vim.fn.system {
          'scp',
          '-q',
          abs,
          lunette.dest_host .. ':' .. dst,
        }
      end,
    })
  else
    print 'Lunette autocommand can only be toggled in the source directory'
  end
end

vim.api.nvim_create_user_command('LunetteToggleRsync', function()
  lunette.toggle_rsync_autocmd()
end, { desc = 'Toggle lunette rsync autocommand' })
lunette.toggle_rsync_autocmd()
