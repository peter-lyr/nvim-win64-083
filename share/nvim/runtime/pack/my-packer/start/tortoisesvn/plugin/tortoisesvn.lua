local a = vim.api
local s = vim.keymap.set

local loaded_do_tortoisesvn = nil

local sta
local do_tortoisesvn
local tortoisesvn_autocmd

local tortoisesvn = function(params)
  if not loaded_do_tortoisesvn then
    loaded_do_tortoisesvn = 1
    sta, do_tortoisesvn = pcall(require, 'do_tortoisesvn')
    if not sta then
      print(do_tortoisesvn)
      return
    end
  end
  if tortoisesvn_autocmd then
    a.nvim_del_autocmd(tortoisesvn_autocmd)
    tortoisesvn_autocmd = nil
  end
  if not do_tortoisesvn then
    return
  end
  do_tortoisesvn.run(params)
end


tortoisesvn_autocmd = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    tortoisesvn()
  end,
})


a.nvim_create_user_command('TortoisesvN', function(params)
  tortoisesvn(params['fargs'])
end, { nargs = "*", })
