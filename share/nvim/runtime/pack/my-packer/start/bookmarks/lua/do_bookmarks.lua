local c = vim.cmd
local g = vim.g
local s = vim.keymap.set


g.bookmarks_do_loaded = 1
g.bookmark_save_per_working_dir = 1
g.bookmark_auto_save = 1
g.bookmark_no_default_key_mappings = 1


local sta, packadd = pcall(c, 'packadd vim-bookmarks')
if not sta then
  print(packadd)
  local opt = { silent = true }
  s({ 'n', 'v' }, 'ma', ':ec "no bookmarks"<cr>', opt)
  s({ 'n', 'v' }, 'mm', ':ec "no bookmarks"<cr>', opt)
  s({ 'n', 'v' }, 'mi', ':ec "no bookmarks"<cr>', opt)
  s({ 'n', 'v' }, 'ms', ':ec "no bookmarks"<cr>', opt)
  s({ 'n', 'v' }, 'mw', ':ec "no bookmarks"<cr>', opt)
  s({ 'n', 'v' }, 'mc', ':ec "no bookmarks"<cr>', opt)
  s({ 'n', 'v' }, 'mx', ':ec "no bookmarks"<cr>', opt)
  s({ 'n', 'v' }, 'mkk', ':ec "no bookmarks"<cr>', opt)
  s({ 'n', 'v' }, 'mjj', ':ec "no bookmarks"<cr>', opt)
  s({ 'n', 'v' }, 'mg', ':ec "no bookmarks"<cr>', opt)
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
