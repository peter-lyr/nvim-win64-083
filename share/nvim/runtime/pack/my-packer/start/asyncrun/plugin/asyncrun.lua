local a = vim.api

local asyncrun_cursormoved

asyncrun_cursormoved = a.nvim_create_autocmd({ "CursorMoved" }, {
  callback = function()
    a.nvim_del_autocmd(asyncrun_cursormoved)
    local sta, do_asyncrun = pcall(require, 'do_asyncrun')
    if not sta then
      print(do_asyncrun)
      return
    end
  end,
})
