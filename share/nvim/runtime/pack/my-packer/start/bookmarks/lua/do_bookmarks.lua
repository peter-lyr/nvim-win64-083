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
