local a = vim.api
local s = vim.keymap.set

local loaded_do_tortoisesvn = nil

local sta
local do_tortoisesvn

local tortoisesvn_exe = function(params)
  if not loaded_do_tortoisesvn then
    loaded_do_tortoisesvn = 1
    sta, do_tortoisesvn = pcall(require, 'do_tortoisesvn')
    if not sta then
      print(do_tortoisesvn)
      return
    end
  end
  if not do_tortoisesvn then
    return
  end
  do_tortoisesvn.run(params)
end

a.nvim_create_user_command('TortoisesvN', function(params)
  tortoisesvn_exe(params['fargs'])
end, { nargs = "*", })


local opt = { silent = true }

s({ 'n', 'v' }, '<leader>vi', ':<c-u>TortoisesvN<cr>', opt)
