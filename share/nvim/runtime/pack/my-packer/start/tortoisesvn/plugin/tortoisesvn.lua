local a = vim.api
local g = vim.g
local s = vim.keymap.set

local sta

local tortoisesvn_exe = function(cmd, root, yes)
  if not g.loaded_do_tortoisesvn then
    g.loaded_do_tortoisesvn = 1
    sta, Do_tortoisesvn = pcall(require, 'do_tortoisesvn')
    if not sta then
      print(Do_tortoisesvn)
      return
    end
  end
  if not Do_tortoisesvn then
    return
  end
  Do_tortoisesvn.run(cmd, root, yes)
end

a.nvim_create_user_command('TortoisesvN', function(params)
  tortoisesvn_exe(unpack(params['fargs']))
end, { nargs = "*", })


local opt = { silent = true }

s({ 'n', 'v' }, '<leader>vi', ':TortoisesvN<cr>', opt)
