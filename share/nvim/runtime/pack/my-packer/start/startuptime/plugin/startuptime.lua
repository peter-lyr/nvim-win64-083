local a = vim.api
local f = vim.fn
local g = vim.g
local s = vim.keymap.set

local sta

g.startuptime_lua = f['expand']('<sfile>')

local startuptime = function()
  if not g.startuptime_loaded then
    g.startuptime_loaded = 1
    if g.startuptime_cursormoved then
      a.nvim_del_autocmd(g.startuptime_cursormoved)
    end
    sta, Do_startuptime = pcall(require, 'do_startuptime')
    if not sta then
      print(Do_startuptime)
      return
    end
  end
  if not Do_startuptime then
    return
  end
  Do_startuptime.run()
end

a.nvim_create_user_command('StartuptimE', function()
  startuptime()
end, { nargs = "*", })

local opt = { silent = true }


s({ 'n', 'v' }, '<leader><leader><leader>y', ':StartuptimE<cr>', opt)
