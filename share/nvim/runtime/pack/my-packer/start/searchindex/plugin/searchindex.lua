local a = vim.api
local c = vim.cmd

local searchindex_cursormoved = nil

searchindex_cursormoved = a.nvim_create_autocmd({ "CursorMoved" }, {
  callback = function()
    a.nvim_del_autocmd(searchindex_cursormoved)
    local sta, packadd = pcall(c, 'packadd vim-searchindex')
    if not sta then
      print(packadd)
      return
    end
  end,
})
