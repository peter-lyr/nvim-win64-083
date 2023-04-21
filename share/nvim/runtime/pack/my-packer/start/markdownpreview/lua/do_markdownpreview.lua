local M = {}

local g = vim.g
local c = vim.cmd
local o = vim.opt

local sta

local packadd
sta, packadd = pcall(c, 'packadd markdown-preview.nvim')
if not sta then
  print(packadd)
  return
end

local Path
sta, Path = pcall(require, "plenary.path")
if not Path then
  print(Path)
  return
end

local path = Path:new(g.markdownpreview_lua)
path = path:parent():parent()
g.mkdp_markdown_css = path:joinpath('autoload', 'mkdp_markdown.css')['filename']

function M.do_markdownpreview(cmd)
  if o.ft:get() == 'markdown' then
    sta, _ = pcall(c, cmd)
    if not sta then
      print('BufEnter and try again')
    end
  end
end

return M
