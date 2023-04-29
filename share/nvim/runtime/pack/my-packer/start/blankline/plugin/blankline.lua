local a = vim.api

local blankline_loaded = nil

local blankline = function()
  if not blankline_loaded then
    blankline_loaded = 1
    local sta, do_blankline = pcall(require, 'do_blankline')
    if not sta then
      print(do_blankline)
      return
    end
  end
end

local blankline_cursormoved
blankline_cursormoved = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    a.nvim_del_autocmd(blankline_cursormoved)
    blankline()
  end,
})
