local a = vim.api

local highlighter_cursormoved

highlighter_cursormoved = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    a.nvim_del_autocmd(highlighter_cursormoved)
    local sta, do_highlighter = pcall(require, 'do_highlighter')
    if not sta then
      print(do_highlighter)
      return
    end
  end,
})
