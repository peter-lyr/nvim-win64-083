local a = vim.api
local c = vim.cmd

local asyncrun_cursormoved = nil

asyncrun_cursormoved = a.nvim_create_autocmd({ "CursorMoved" }, {
  callback = function()
    a.nvim_del_autocmd(asyncrun_cursormoved)
    local sta, packadd = pcall(c, 'packadd asyncrun.vim')
    if not sta then
      print(packadd)
      return
    end
  end,
})
