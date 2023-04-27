local c = vim.cmd
local f = vim.fn
local g = vim.g

local sta

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

if not add_pack_help({ 'ultisnips' }) then
  return nil
end
