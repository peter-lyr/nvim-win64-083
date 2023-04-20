local a = vim.api
local f = vim.fn
local g = vim.g
local s = vim.keymap.set

local sta

g.startuptime_lua = f['expand']('<sfile>')

local startuptime = function(params)
  if not g.startuptime_loaded then
    g.startuptime_loaded = 1
    a.nvim_del_autocmd(g.startuptime_cursormoved)
    sta, Do_startuptime = pcall(require, 'do_startuptime')
    if not sta then
      print(Do_startuptime)
      return
    end
  end
  if not Do_startuptime then
    return
  end
  Do_startuptime.run(params)
end

a.nvim_create_user_command('StartuptimE', function(params)
  startuptime(params['fargs'])
end, { nargs = '*', })

if not g.startuptime_startup then
  g.startuptime_startup = 1
  g.startuptime_cursormoved = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
    callback = function()
      startuptime()
    end,
  })
end


local opt = { silent = true }

s({ 'n', 'v' }, '<leader><leader><leader>y', ':StartuptimE do<cr>', opt)
