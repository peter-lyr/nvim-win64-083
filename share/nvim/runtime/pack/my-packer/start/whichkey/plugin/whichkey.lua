local a = vim.api
local g = vim.g

local whichkey = function()
  if not g.whichkey_loaded then
    g.whichkey_loaded = 1
    local sta, whichkey = pcall(require, "which-key")
    if not sta then
      print(whichkey)
      return
    end
    whichkey.setup({})
  end
end

if not g.whichkey_startup then
  g.whichkey_startup = 1
  g.whichkey_cursormoved = a.nvim_create_autocmd({ "CursorMoved", "FocusLost" }, {
    callback = function()
      a.nvim_del_autocmd(g.whichkey_cursormoved)
      whichkey()
    end,
  })
end
