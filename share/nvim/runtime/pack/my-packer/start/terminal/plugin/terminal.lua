local a = vim.api
local g = vim.g
local s = vim.keymap.set


g.builtin_terminal_ok = 1


local terminal_cursormoved = nil
local loaded_do_terminal = nil

local sta

local terminal = function(params)
  if not loaded_do_terminal then
    loaded_do_terminal = 1
    a.nvim_del_autocmd(terminal_cursormoved)
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

terminal_cursormoved = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    terminal()
  end,
})

a.nvim_create_user_command('TerminaL', function(params)
  terminal(params['fargs'])
end, { nargs = '*', })


local opt = { silent = true }

s({ 'n', 'v' }, '\\q', ':TerminaL cmd<cr>', opt)
s({ 'n', 'v' }, '\\w', ':TerminaL ipython<cr>', opt)
s({ 'n', 'v' }, '\\e', ':TerminaL bash<cr>', opt)
s({ 'n', 'v' }, '\\r', ':TerminaL powershell<cr>', opt)
