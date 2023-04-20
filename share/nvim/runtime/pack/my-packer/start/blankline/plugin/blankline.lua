local a = vim.api
local f = vim.fn
local g = vim.g

local sta

g.blankline_lua = f['expand']('<sfile>')

local blankline = function()
  if not g.blankline_loaded then
    g.blankline_loaded = 1
    if g.blankline_cursormoved then
      a.nvim_del_autocmd(g.blankline_cursormoved)
    end
    sta, Do_blankline = pcall(require, 'do_blankline')
    if not sta then
      print(Do_blankline)
      return
    end
  end
  if not Do_blankline then
    return
  end
  Do_blankline.run()
end

if not g.blankline_startup then
  g.blankline_startup = 1
  g.blankline_cursormoved = a.nvim_create_autocmd({"CursorMoved", "FocusLost"}, {
    callback = function()
      blankline()
    end,
  })
end
