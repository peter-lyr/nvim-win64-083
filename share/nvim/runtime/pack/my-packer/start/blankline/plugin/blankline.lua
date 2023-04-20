local a = vim.api
local g = vim.g

local blankline_loaded = nil

local sta

local blankline = function()
  if not blankline_loaded then
    blankline_loaded = 1
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

g.blankline_cursormoved = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    blankline()
  end,
})
