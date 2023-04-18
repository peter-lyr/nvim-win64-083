local c = vim.cmd

local sta, packadd = pcall(c, 'packadd vim-bad-whitespace')
if not sta then
  print(packadd)
  return
end

local M = {}

M.run = function(params)
  if not params or #params == 0 then
    return
  end
  c(params[1] .. 'BadWhitespace')
end

return M
