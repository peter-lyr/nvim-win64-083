local a = vim.api
local s = vim.keymap.set

local hop_loaded = nil

local sta

local hop = function(params)
  if not hop_loaded then
    hop_loaded = 1
    sta, Do_hop = pcall(require, 'do_hop')
    if not sta then
      print(Do_hop)
      return
    end
  end
  if not Do_hop then
    return
  end
  Do_hop.run(params)
end

a.nvim_create_user_command('HoP', function(params)
  hop(params['fargs'])
end, { nargs = '*', })


local opt = { silent = true }

s('n', 's', ':HoP Char1<cr>', opt)
s('n', 'f', ':HoP Char2<cr>', opt)
