local a = vim.api
local c = vim.cmd

local bufferclean_cursormoved

bufferclean_cursormoved = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    a.nvim_create_autocmd(bufferclean_cursormoved)
    local sta, packadd = pcall(c, 'packadd vim-highlighter')
    if not sta then
      print(packadd)
    end
  end,
})
