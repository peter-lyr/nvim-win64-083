local a = vim.api
local s = vim.keymap.set

local do_bookmarks = nil
local bookmarks_loaded = nil

local sta

local bookmarks = function(params)
  if not bookmarks_loaded then
    bookmarks_loaded = 1
    sta, do_bookmarks = pcall(require, 'do_bookmarks')
    if not sta then
      print(do_bookmarks)
      return
    end
  end
  if not do_bookmarks then
    return
  end
  do_bookmarks.run(params)
end

a.nvim_create_user_command('BookmarkS', function(params)
  bookmarks(params['fargs'])
end, { nargs = "*", })

local opt = { silent = true }

s('n', 'ma', ':<c-u>BookmarkS BookmarkShowAll<cr>', opt)
s('n', 'mm', ':<c-u>BookmarkS BookmarkToggle<cr>', opt)
s('n', 'mi', ':<c-u>BookmarkS BookmarkAnnotate<cr>', opt)
s('n', 'ms', ':<c-u>BookmarkS BookmarkNext<cr>', opt)
s('n', 'mw', ':<c-u>BookmarkS BookmarkPrev<cr>', opt)
s('n', 'mc', ':<c-u>BookmarkS BookmarkClear<cr>', opt)
s('n', 'mx', ':<c-u>BookmarkS BookmarkClearAll<cr>', opt)
s('n', 'mkk', ':<c-u>BookmarkS BookmarkMoveUp<cr>', opt)
s('n', 'mjj', ':<c-u>BookmarkS BookmarkMoveDown<cr>', opt)
s('n', 'mg', ':<c-u>BookmarkS BookmarkMoveToLine<cr>', opt)
