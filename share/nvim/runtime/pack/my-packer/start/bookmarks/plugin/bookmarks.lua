local a = vim.api
local g = vim.g
local s = vim.keymap.set

local bookmarks = function(params)
  if not g.bookmarks_loaded then
    g.bookmarks_loaded = 1
    local sta
    sta, g.do_bookmarks = pcall(require, 'do_bookmarks')
    if not sta then
      print("no do_bookmarks:", g.do_bookmarks)
      return
    end
  end
  if not g.do_bookmarks then
    return
  end
  g.do_bookmarks.run(params)
end

a.nvim_create_user_command('BookmarkS', function(params)
  bookmarks(params['fargs'])
end, { nargs = "*", })

local opt = { silent = true }

s('n', 'ma', ':BookmarkS BookmarkShowAll<cr>', opt)
s('n', 'mm', ':BookmarkS BookmarkToggle<cr>', opt)
s('n', 'mi', ':BookmarkS BookmarkAnnotate<cr>', opt)
s('n', 'ms', ':BookmarkS BookmarkNext<cr>', opt)
s('n', 'mw', ':BookmarkS BookmarkPrev<cr>', opt)
s('n', 'mc', ':BookmarkS BookmarkClear<cr>', opt)
s('n', 'mx', ':BookmarkS BookmarkClearAll<cr>', opt)
s('n', 'mkk', ':BookmarkS BookmarkMoveUp<cr>', opt)
s('n', 'mjj', ':BookmarkS BookmarkMoveDown<cr>', opt)
s('n', 'mg', ':BookmarkS BookmarkMoveToLine<cr>', opt)
