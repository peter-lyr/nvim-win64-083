local c = vim.cmd
local g = vim.g
local s = vim.keymap.set
local f = vim.fn


g.bookmarks_do_loaded = 1
g.bookmark_save_per_working_dir = 1
g.bookmark_auto_save = 1
g.bookmark_no_default_key_mappings = 1

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

if not add_pack_help({ 'vim-bookmarks' }) then
  local opt = { silent = true }
  s('n', 'ma', ':ec "no bookmarks"<cr>', opt)
  s('n', 'mm', ':ec "no bookmarks"<cr>', opt)
  s('n', 'mi', ':ec "no bookmarks"<cr>', opt)
  s('n', 'ms', ':ec "no bookmarks"<cr>', opt)
  s('n', 'mw', ':ec "no bookmarks"<cr>', opt)
  s('n', 'mc', ':ec "no bookmarks"<cr>', opt)
  s('n', 'mx', ':ec "no bookmarks"<cr>', opt)
  s('n', 'mkk', ':ec "no bookmarks"<cr>', opt)
  s('n', 'mjj', ':ec "no bookmarks"<cr>', opt)
  s('n', 'mg', ':ec "no bookmarks"<cr>', opt)
  return nil
end


local M = {}

M.run = function(params)
  if not params or #params == 0 then
    return
  end
  local cmd = table.concat(params, ' ')
  c(cmd)
end

return M
