local a = vim.api
local g = vim.g
local s = vim.keymap.set

local sta

local hop = function(params)
  if not g.hop_loaded then
    g.hop_loaded = 1
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

s({'n', 'v'}, 'gi', ':HoP Char1<cr>', opt)
s({'n', 'v'}, 'go', ':HoP Char2<cr>', opt)
