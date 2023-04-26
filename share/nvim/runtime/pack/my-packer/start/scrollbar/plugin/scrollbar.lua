local a = vim.api

local scrollbar_cursormoved

scrollbar_cursormoved = a.nvim_create_autocmd({ "CursorMoved" }, {
  callback = function()
    a.nvim_del_autocmd(scrollbar_cursormoved)
    local sta, do_scrollbar = pcall(require, 'do_scrollbar')
    if not sta then
      print(do_scrollbar)
      return
    end
  end,
})
