local a = vim.api
local g = vim.g
local s = vim.keymap.set


g.builtin_terminal_ok = 1


local terminal_cursormoved = nil
local loaded_do_terminal = nil

local sta
local do_terminal

local terminal = function(params)
  if not loaded_do_terminal then
    loaded_do_terminal = 1
    a.nvim_del_autocmd(terminal_cursormoved)
    sta, do_terminal = pcall(require, 'do_terminal')
    if not sta then
      print(do_terminal)
      return
    end
  end
  if not do_terminal then
    return
  end
  do_terminal.run(params)
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

s({ 'n', 'v' }, '\\q', ':<c-u>TerminaL cmd<cr>', opt)
s({ 'n', 'v' }, '\\w', ':<c-u>TerminaL ipython<cr>', opt)
s({ 'n', 'v' }, '\\e', ':<c-u>TerminaL bash<cr>', opt)
s({ 'n', 'v' }, '\\r', ':<c-u>TerminaL powershell<cr>', opt)
