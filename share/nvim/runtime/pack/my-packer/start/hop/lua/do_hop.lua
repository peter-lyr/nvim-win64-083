local c = vim.cmd

local sta
local packadd
local hop

sta, packadd = pcall(c, 'packadd hop.nvim')
if not sta then
  print(packadd)
  return
end

sta, hop = pcall(require, 'hop')
if not sta then
  print(hop)
  return
end

hop.setup{}

local M = {}

M.run = function(params)
  if not params or #params == 0 then
    return
  end
  c('Hop' .. params[1])
end

return M
