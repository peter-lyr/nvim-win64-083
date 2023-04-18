local a = vim.api
local g = vim.g
local s = vim.keymap.set

local bookmarks = function(params)
  if not g.bookmarks_loaded then
    g.bookmarks_loaded = 1
    local sta
    sta, Do_bookmarks = pcall(require, 'do_bookmarks')
    if not sta then
      print("no do_bookmarks:", Do_bookmarks)
      return
    end
  end
  if not Do_bookmarks then
    return
  end
  Do_bookmarks.run(params)
end

a.nvim_create_user_command('BookmarkS', function(params)
  bookmarks(params['fargs'])
end, { nargs = "*", })

local opt = { silent = true }

s({ 'n', 'v' }, 'ma', ':BookmarkS BookmarkShowAll<cr>', opt)
s({ 'n', 'v' }, 'mm', ':BookmarkS BookmarkToggle<cr>', opt)
s({ 'n', 'v' }, 'mi', ':BookmarkS BookmarkAnnotate<cr>', opt)
s({ 'n', 'v' }, 'ms', ':BookmarkS BookmarkNext<cr>', opt)
s({ 'n', 'v' }, 'mw', ':BookmarkS BookmarkPrev<cr>', opt)
s({ 'n', 'v' }, 'mc', ':BookmarkS BookmarkClear<cr>', opt)
s({ 'n', 'v' }, 'mx', ':BookmarkS BookmarkClearAll<cr>', opt)
s({ 'n', 'v' }, 'mkk', ':BookmarkS BookmarkMoveUp<cr>', opt)
s({ 'n', 'v' }, 'mjj', ':BookmarkS BookmarkMoveDown<cr>', opt)
s({ 'n', 'v' }, 'mg', ':BookmarkS BookmarkMoveToLine<cr>', opt)
