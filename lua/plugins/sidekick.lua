local M = { claude_pane = nil }

local config = {
  search_patterns = { 'claude', 'node' },
  notify_on_reload = true,
}
--  TODO: auto select pane (the most recent used)
-- Find tmux panes running Claude Code
-- TODO: select function below cursor or line
-- TODO: package into a plugin
local function find_claude_panes()
  if vim.fn.executable 'tmux' ~= 1 or not vim.env.TMUX then
    vim.notify('tmux is not available', vim.log.levels.ERROR)
    return {}
  end

  local panes = {}
  local cmd = 'tmux list-panes -a -F "#{session_name}:#{window_index}.#{pane_index}|#{pane_current_command}|#{pane_title}"'
  local handle = io.popen(cmd)
  if not handle then
    return panes
  end

  for line in handle:lines() do
    local pane_id, command, title = line:match '([^|]+)|([^|]+)|([^|]*)'
    if command then
      for _, pattern in ipairs(config.search_patterns) do
        if command:lower():match(pattern) or (title and title:lower():match(pattern)) then
          table.insert(panes, { id = pane_id, command = command, title = title or 'No title' })
          break
        end
      end
    end
  end

  handle:close()
  return panes
end

-- Select Claude Code pane
local function select_claude_pane()
  local panes = find_claude_panes()

  if #panes == 0 then
    vim.notify('No Claude Code pane found', vim.log.levels.ERROR)
    return nil
  elseif #panes == 1 then
    M.claude_pane = panes[1].id
    vim.notify('Found Claude Code pane: ' .. M.claude_pane, vim.log.levels.INFO)
    return M.claude_pane
  end

  vim.ui.select(panes, {
    prompt = 'Select Claude Code pane:',
    format_item = function(item)
      return string.format('%s (%s) - %s', item.id, item.command, item.title)
    end,
  }, function(choice)
    if choice then
      M.claude_pane = choice.id
      vim.notify('Selected: ' .. M.claude_pane, vim.log.levels.INFO)
    end
  end)

  return M.claude_pane
end

-- Send text via tmux buffer
local function send_to_claude(text)
  if not text or text == '' then
    vim.notify('No text to send', vim.log.levels.WARN)
    return
  end

  if not M.claude_pane then
    select_claude_pane()
    if not M.claude_pane then
      return
    end
  end

  local tmpfile = vim.fn.tempname()
  local file = io.open(tmpfile, 'w')
  if not file then
    vim.notify('Failed to create temp file', vim.log.levels.ERROR)
    return
  end

  file:write(text)
  file:close()

  vim.fn.system(string.format("tmux load-buffer '%s'", tmpfile))
  vim.fn.system(string.format("tmux paste-buffer -t '%s'", M.claude_pane))
  os.remove(tmpfile)

  vim.notify('Sent to Claude Code', vim.log.levels.INFO)
end

-- Add current buffer to Claude context
local function add_current_buffer()
  local filepath = vim.fn.expand '%:p'
  if filepath == '' then
    vim.notify('No file in buffer', vim.log.levels.WARN)
    return
  end
  send_to_claude('@' .. filepath)
end

-- Send visual selection as file reference
local function send_selection()
  local filepath = vim.fn.expand '%:p'
  if filepath == '' then
    vim.notify('No file in buffer', vim.log.levels.WARN)
    return
  end

  local start_line = vim.fn.getpos("'<")[2]
  local end_line = vim.fn.getpos("'>")[2]

  local reference = start_line == end_line and string.format('%s:%d', filepath, start_line) or string.format('%s:%d-%d', filepath, start_line, end_line)

  send_to_claude(reference)
end

-- Setup auto-reload
local function setup_autoreload()
  vim.opt.autoread = true
  vim.opt.updatetime = 25

  local augroup = vim.api.nvim_create_augroup('ClaudeCodeAutoReload', { clear = true })

  vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
    group = augroup,
    callback = function()
      if vim.fn.mode() ~= 'c' then
        vim.cmd 'checktime'
      end
    end,
    desc = 'Auto-reload files changed by Claude Code',
  })

  if config.notify_on_reload then
    vim.api.nvim_create_autocmd('FileChangedShellPost', {
      group = augroup,
      callback = function()
        vim.notify('Reloaded: ' .. vim.fn.expand '%', vim.log.levels.INFO)
      end,
    })
  end
end

-- Setup keybindings
local function setup_keymaps()
  local opts = { noremap = true, silent = true }
  vim.keymap.set('n', '<leader>kc', select_claude_pane, vim.tbl_extend('force', opts, { desc = 'Select Claude pane' }))
  vim.keymap.set('n', '<leader>kb', add_current_buffer, vim.tbl_extend('force', opts, { desc = 'Add current buffer' }))
  vim.keymap.set('v', '<leader>ks', send_selection, vim.tbl_extend('force', opts, { desc = 'Send selection' }))
end

-- Initialize
setup_autoreload()
setup_keymaps()

return {}
