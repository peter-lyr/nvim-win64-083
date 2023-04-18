local g = vim.g
local c = vim.cmd

g.auto_save = 1
g.auto_save_silent = 1
g.auto_save_events = {'InsertLeave', 'TextChanged', 'TextChangedI', 'CursorHold', 'CursorHoldI', 'CompleteDone'}

local sta, packadd = pcall(c, 'packadd vim-auto-save')
if not sta then
  print(packadd)
  return
end

local M = {}

M.run = function()
end

return M
