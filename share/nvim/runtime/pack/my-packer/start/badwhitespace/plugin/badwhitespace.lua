local a = vim.api
local g = vim.g
local s = vim.keymap.set

local sta

local badwhitespace = function(params)
  if not g.badwhitespace_loaded then
    g.badwhitespace_loaded = 1
    a.nvim_del_autocmd(g.badwhitespace_cursormoved)
    sta, Do_badwhitespace = pcall(require, 'do_badwhitespace')
    if not sta then
      print(Do_badwhitespace)
      return
    end
  end
  if not Do_badwhitespace then
    return
  end
  Do_badwhitespace.run(params)
end

a.nvim_create_user_command('BadwhitespacE', function(params)
  badwhitespace(params['fargs'])
end, { nargs = '*', })

if not g.badwhitespace_startup then
  g.badwhitespace_startup = 1
  g.badwhitespace_cursormoved = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
    callback = function()
      badwhitespace()
    end,
  })
end


local opt = { silent = true }

s({ 'n', 'v' }, '<leader>ee', ':BadwhitespacE Erase<cr>', opt)
s({ 'n', 'v' }, '<leader>eh', ':BadwhitespacE Hide<cr> ', opt)
s({ 'n', 'v' }, '<leader>es', ':BadwhitespacE Show<cr> ', opt)
