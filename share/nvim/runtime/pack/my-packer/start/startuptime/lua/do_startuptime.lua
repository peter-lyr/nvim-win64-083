local c = vim.cmd
local f = vim.fn
local g = vim.g

local M = {}

g.auto_save = 1
g.auto_save_silent = 1
g.auto_save_events = {'InsertLeave', 'TextChanged', 'TextChangedI', 'CursorHold', 'CursorHoldI', 'CompleteDone'}
g.session_autoload = 'no'
g.session_autosave = 'yes'

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

if not add_pack_help({ 'vim-startuptime' }) then
  return nil
end

M.run = function(params)
  if not params or #params == 0 then
    return
  end
  c'StartupTime'
end

return M
