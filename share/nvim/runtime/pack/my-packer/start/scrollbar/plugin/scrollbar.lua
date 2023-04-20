local a = vim.api
local c = vim.cmd

local scrollbar_cursormoved = nil

local sta

scrollbar_cursormoved = a.nvim_create_autocmd({ "CursorMoved" }, {
  callback = function()
    a.nvim_del_autocmd(scrollbar_cursormoved)
    local packadd
    sta, packadd = pcall(c, 'packadd nvim-scrollview')
    if not sta then
      print(packadd)
      return
    end
    local scrollview
    sta, scrollview = pcall(require, 'scrollview')
    if not sta then
      print(scrollview)
      return
    end
    scrollview.setup()
  end,
})
