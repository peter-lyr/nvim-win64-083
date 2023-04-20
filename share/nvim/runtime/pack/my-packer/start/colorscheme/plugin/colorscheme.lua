local a = vim.api
local c = vim.cmd

local colorscheme_cursormoved = nil

colorscheme_cursormoved = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    a.nvim_del_autocmd(colorscheme_cursormoved)
    local sta, colorscheme = pcall(c, 'colorscheme sierra')
    if not sta then
      print(colorscheme)
      return
    end
  end,
})
