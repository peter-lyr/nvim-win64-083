local a = vim.api
local g = vim.g
local s = vim.keymap.set


g.builtin_terminal_ok = 1


local sta

local terminal = function(params)
  if not g.loaded_do_terminal then
    g.loaded_do_terminal = 1
    a.nvim_del_autocmd(g.terminal_cursormoved)
    sta, Do_terminal = pcall(require, 'do_terminal')
    if not sta then
      print(Do_terminal)
      return
    end
  end
  if not Do_terminal then
    return
  end
  Do_terminal.run(params)
end

if not g.terminal_startup then
  g.terminal_startup = 1
  g.terminal_cursormoved = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
    callback = function()
      terminal()
    end,
  })
end

a.nvim_create_user_command('TerminaL', function(params)
  terminal(params['fargs'])
end, { nargs = '*', })


local opt = { silent = true }

s({ 'n', 'v' }, '\\q', ':TerminaL cmd<cr>', opt)
s({ 'n', 'v' }, '\\w', ':TerminaL ipython<cr>', opt)
s({ 'n', 'v' }, '\\e', ':TerminaL bash<cr>', opt)
s({ 'n', 'v' }, '\\r', ':TerminaL powershell<cr>', opt)
