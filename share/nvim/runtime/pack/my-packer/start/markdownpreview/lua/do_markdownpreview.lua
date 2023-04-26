local M = {}

local g = vim.g
local c = vim.cmd
local o = vim.opt
local f = vim.fn

local sta

local add_pack_help = function(plugnames)
  local _sta, _path
  _sta, _path = pcall(require, "plenary.path")
  if not _sta then
    print(_path)
    return nil
  end
  local doc_path
  local packadd
  _path = _path:new(f.expand("$VIMRUNTIME"))
  local opt_path = _path:joinpath('pack', 'packer', 'opt')
  for _, plugname in ipairs(plugnames) do
    doc_path = opt_path:joinpath(plugname, 'doc')
    _sta, packadd = pcall(c, 'packadd ' .. plugname)
    if not _sta then
      print(packadd)
      return nil
    end
    if doc_path:is_dir() then
      c('helptags ' .. doc_path.filename)
    end
  end
  return true
end

if not add_pack_help({ 'markdown-preview.nvim' }) then
  return nil
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
