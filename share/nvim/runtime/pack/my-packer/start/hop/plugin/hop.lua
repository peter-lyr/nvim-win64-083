local a = vim.api
local s = vim.keymap.set

local hop_loaded = nil

local sta
local do_hop

local hop = function(params)
  if not hop_loaded then
    hop_loaded = 1
    sta, do_hop = pcall(require, 'do_hop')
    if not sta then
      print(do_hop)
      return
    end
  end
  if not do_hop then
    return
  end
  do_hop.run(params)
end

a.nvim_create_user_command('HoP', function(params)
  hop(params['fargs'])
end, { nargs = '*', })


local opt = { silent = true }

s('n', 's', ':HoP Char1<cr>', opt)
s('n', 'f', ':HoP Char2<cr>', opt)
