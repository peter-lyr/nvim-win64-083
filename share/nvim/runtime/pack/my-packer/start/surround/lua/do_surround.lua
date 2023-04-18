local c = vim.cmd

local sta, packadd = pcall(c, 'packadd vim-surround')
if not sta then
  print(packadd)
  return
end
