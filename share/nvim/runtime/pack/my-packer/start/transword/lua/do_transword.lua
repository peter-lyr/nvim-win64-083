local f = vim.fn
local g = vim.g

local M = {}

local Path = require("plenary.path")

local transword_path = Path:new(g.transword_lua):parent():parent()
local transword_py_path = transword_path:joinpath('autoload', 'transword.py')

M.run = function()
  if transword_py_path:exists() then
    print('no transword_py')
    return
  end
  if not Do_terminal then
    print('no Do_terminal')
  end
  local cmd = 'python ' .. transword_py_path.filename .. ' ' .. f['expand']('<cword>')
  Do_terminal.send_cmd('cmd', cmd, 'show')
end

return M
