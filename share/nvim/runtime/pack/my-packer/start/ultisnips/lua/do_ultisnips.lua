local c = vim.cmd
local g = vim.g

local sta
local packadd

g.UltiSnipsJumpForwardTrigger = "<a-.>"
g.UltiSnipsJumpBackwardTrigger = "<a-,>"

sta, Path = pcall(require, 'plenary.path')
if not sta then
  print(Path)
  return
end

local path = Path:new(g.ultisnips_lua)
g.ultisnips_dir = path:parent():parent():joinpath('autoload')['filename']
g.UltiSnipsSnippetDirectories = {g.ultisnips_dir}

sta, packadd = pcall(c, 'packadd ultisnips')
if not sta then
  print(packadd)
end
