local a = vim.api
local s = vim.keymap.set

local startuptime_cursormoved = nil
local startuptime_loaded = nil

local sta
local do_startuptime

local startuptime = function(params)
  if not startuptime_loaded then
    startuptime_loaded = 1
    a.nvim_del_autocmd(startuptime_cursormoved)
    sta, do_startuptime = pcall(require, 'do_startuptime')
    if not sta then
      print(do_startuptime)
      return
    end
  end
  if not do_startuptime then
    return
  end
  do_startuptime.run(params)
end

a.nvim_create_user_command('StartuptimE', function(params)
  startuptime(params['fargs'])
end, { nargs = '*', })

startuptime_cursormoved = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    startuptime()
  end,
})


local opt = { silent = true }

s({ 'n', 'v' }, '<leader><leader><leader>y', ':<c-u>StartuptimE do<cr>', opt)
