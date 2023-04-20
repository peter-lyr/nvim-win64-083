local a = vim.api

local whichkey_loaded = nil
local whichkey_cursormoved = nil

local whichkey = function()
  if not whichkey_loaded then
    whichkey_loaded = 1
    a.nvim_del_autocmd(whichkey_cursormoved)
    local sta, whichkey = pcall(require, 'which-key')
    if not sta then
      print(whichkey)
      return
    end
    whichkey.setup({})
  end
end

whichkey_cursormoved = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    whichkey()
  end,
})
