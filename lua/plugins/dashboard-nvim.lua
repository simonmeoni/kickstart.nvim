return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  dependencies = { { 'nvim-tree/nvim-web-devicons' } },
  config = function()
    require('dashboard').setup {
      theme = 'doom',
      config = {
        header = {
          '',
          '',
          '',
          '            :h-                                  Nhy`               ',
          '           -mh.                           h.    `Ndho               ',
          '           hmh+                          oNm.   oNdhh               ',
          '          `Nmhd`                        /NNmd  /NNhhd               ',
          '          -NNhhy                      `hMNmmm`+NNdhhh               ',
          '          .NNmhhs              ```....`..-:/./mNdhhh+               ',
          '           mNNdhhh-     `.-::///+++////++//:--.`-/sd`               ',
          '           oNNNdhhdo..://++//++++++/+++//++///++/-.`                ',
          '      y.   `mNNNmhhhdy+/++++//+/////++//+++///++////-` `/oos:       ',
          ' .    Nmy:  :NNNNmhhhhdy+/++/+++///:.....--:////+++///:.`:s+        ',
          ' h-   dNmNmy oNNNNNdhhhhy:/+/+++/-         ---:/+++//++//.`         ',
          ' hd+` -NNNy`./dNNNNNhhhh+-://///    -+oo:`  ::-:+////++///:`        ',
          ' /Nmhs+oss-:++/dNNNmhho:--::///    /mmmmmo  ../-///++///////.       ',
          '  oNNdhhhhhhhs//osso/:---:::///    /yyyyso  ..o+-//////////:/.      ',
          '   /mNNNmdhhhh/://+///::://////     -:::- ..+sy+:////////::/:/.     ',
          '     /hNNNdhhs--:/+++////++/////.      ..-/yhhs-/////////::/::/`    ',
          '       .ooo+/-::::/+///////++++//-/ossyyhhhhs/:///////:::/::::/:    ',
          '       -///:::::::////++///+++/////:/+ooo+/::///////.::://::---+`   ',
          '       /////+//++++/////+////-..//////////::-:::--`.:///:---:::/:   ',
          '       //+++//++++++////+++///::--                 .::::-------::   ',
          '       :/++++///////////++++//////.                -:/:----::../-   ',
          '       -/++++//++///+//////////////               .::::---:::-.+`   ',
          '       `////////////////////////////:.            --::-----...-/    ',
          '        -///://////////////////////::::-..      :-:-:-..-::.`.+`    ',
          '         :/://///:///::://::://::::::/:::::::-:---::-.-....``/- -   ',
          '           ::::://::://::::::::::::::----------..-:....`.../- -+oo/ ',
          '            -/:::-:::::---://:-::-::::----::---.-.......`-/.      ``',
          '           s-`::--:::------:////----:---.-:::...-.....`./:          ',
          '          yMNy.`::-.--::..-dmmhhhs-..-.-.......`.....-/:`           ',
          '         oMNNNh. `-::--...:NNNdhhh/.--.`..``.......:/-              ',
          '        :dy+:`      .-::-..NNNhhd+``..`...````.-::-`                ',
          '                        .-:mNdhh:.......--::::-`                    ',
          '                           yNh/..------..`                          ',
          '',
          '',
          '',
        },

        center = {
          { desc = 'New File', key = 'n', action = 'enew' },
          { desc = 'Find File', key = 'f', action = ":lua Snacks.dashboard.pick('files')" },
          { desc = 'Find Word', key = 'w', action = ":lua Snacks.dashboard.pick('live_grep')" },
          { desc = 'Recent Files', key = 'r', action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { desc = 'Open Config', key = 'c', action = 'edit ~/.config/nvim/init.lua' },
          { desc = 'Update Plugins', key = 'u', action = 'Lazy update' },
          { desc = 'Quit Neovim', key = 'q', action = 'qa' },
        },
        -- dashboard.nvim reference
        footer = function()
          local info = {}
          local fortune = require('fortune').get_fortune()
          info[1] = 'Neovim loaded ' .. vim.fn.strftime '%H:%M' .. ' on ' .. vim.fn.strftime '%d/%m/%Y'
          local footer = vim.list_extend(info, fortune)
          return footer
        end,
      },
    }
  end,
}
