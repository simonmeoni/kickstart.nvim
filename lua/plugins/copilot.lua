return {
  'zbirenbaum/copilot.lua',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = '<M-y>', -- accepter la suggestion
          accept_word = '<M-w>', -- accepter un mot
          accept_line = '<M-l>', -- accepter une ligne
          next = '<M-]>', -- suggestion suivante
          prev = '<M-[>', -- suggestion précédente
          dismiss = '<M-d>', -- cacher
        },
      },
      panel = { enabled = false },
    }
  end,
}
