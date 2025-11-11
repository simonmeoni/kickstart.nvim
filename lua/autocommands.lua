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

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'tex', 'bib' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.showbreak = '↪ '
    vim.opt_local.textwidth = 0
    vim.opt_local.wrapmargin = 0
    vim.opt_local.colorcolumn = ''
    vim.opt_local.formatoptions:remove { 't', 'a' }
  end,
})

local lunette = {
  rsync_autocmd_id = nil,
  mappings = {
    ['/Users/Simon/Code/open-nlp/lib/synth-kg'] = '/lustre/fswork/projects/rech/lch/ufw96he/lib/synth-kg',
    ['/Users/Simon/Code/open-nlp/lib/conflicts'] = '/lustre/fswork/projects/rech/lch/ufw96he/lib/conflicts',
    ['/Users/Simon/Code/thesis-metrics'] = '/lustre/fswork/projects/rech/lch/ufw96he/thesis-metrics',
  },
  dest_host = 'ufw96he@jean-zay.idris.fr',
}

function lunette.find_dest_dir(cwd)
  for local_dir, remote_dir in pairs(lunette.mappings) do
    if cwd:find(local_dir, 1, true) == 1 then
      local rel = cwd:sub(#local_dir + 2) -- skip trailing slash
      return local_dir, remote_dir .. '/' .. rel
    end
  end
  return nil, nil
end

function lunette.toggle_rsync_autocmd()
  local cwd = vim.fn.getcwd()
  local matched_source, base_dest = lunette.find_dest_dir(cwd)

  if matched_source then
    vim.notify('Lunette autocommand enabled for: ' .. matched_source, vim.log.levels.INFO)
    lunette.rsync_autocmd_id = vim.api.nvim_create_autocmd('BufWritePost', {
      pattern = '*',
      callback = function(ctx)
        local abs = ctx.file
        local rel = vim.fn.fnamemodify(abs, ':.' .. matched_source)
        local dst = base_dest .. '/' .. rel

        -- Création du dossier distant si besoin
        vim.fn.system {
          'ssh',
          lunette.dest_host,
          'mkdir -p ' .. vim.fn.fnamemodify(dst, ':h'),
        }

        -- Envoi du fichier
        vim.fn.system {
          'scp',
          '-q',
          abs,
          lunette.dest_host .. ':' .. dst,
        }
      end,
    })
  end
  -- Silent when not in a registered directory (no annoying message on every startup)
end

vim.api.nvim_create_user_command('LunetteToggleRsync', function()
  lunette.toggle_rsync_autocmd()
end, { desc = 'Toggle lunette rsync autocommand' })

lunette.toggle_rsync_autocmd()

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*/dummy-sidekick/lua/**/*.lua',
  callback = function()
    vim.notify('🧪 Running tests...', vim.log.levels.INFO)

    -- Run tests in background, don't block editing
    vim.fn.jobstart({
      'nvim',
      '--headless',
      '--noplugin',
      '-u',
      vim.fn.expand '~/Code/dummy-sidekick/tests/minimal_init.lua',
      '-c',
      'PlenaryBustedDirectory ~/Code/dummy-sidekick/tests/',
    }, {
      on_exit = function(_, exit_code)
        if exit_code == 0 then
          vim.schedule(function()
            vim.notify('✅ Tests passed!', vim.log.levels.INFO)
          end)
        else
          vim.schedule(function()
            vim.notify('❌ Tests failed!', vim.log.levels.ERROR)
          end)
        end
      end,
    })
  end,
  desc = 'Auto-run sidekick tests on save',
})
