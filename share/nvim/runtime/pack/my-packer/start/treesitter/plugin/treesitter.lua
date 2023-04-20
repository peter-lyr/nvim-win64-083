local a = vim.api

local treesitter_loaded = nil
local treesitter_cursormoved = nil

local sta

local treesitter = function()
  if not treesitter_loaded then
    treesitter_loaded = 1
    a.nvim_del_autocmd(treesitter_cursormoved)
    sta, Do_treesitter = pcall(require, 'do_treesitter')
    if not sta then
      print(Do_treesitter)
      return
    end
  end
  if not Do_treesitter then
    return
  end
  Do_treesitter.run()
end

treesitter_cursormoved = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    treesitter()
  end,
})
