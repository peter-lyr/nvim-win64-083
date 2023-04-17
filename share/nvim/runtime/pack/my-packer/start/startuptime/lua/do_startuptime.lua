local c = vim.cmd
local g = vim.g

local M = {}

g.auto_save = 1
g.auto_save_silent = 1
g.auto_save_events = {'InsertLeave', 'TextChanged', 'TextChangedI', 'CursorHold', 'CursorHoldI', 'CompleteDone'}
g.session_autoload = 'no'
g.session_autosave = 'yes'

local sta, packadd = pcall(c, 'packadd vim-startuptime')
if not sta then
  print(packadd)
  return nil
end

M.run = function(params)
  if not params or #params == 0 then
    c'StartupTime'
  end
end

return M
