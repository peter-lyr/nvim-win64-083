local a = vim.api
local g = vim.g

local sta

local treesitter = function()
  if not g.treesitter_loaded then
    g.treesitter_loaded = 1
    a.nvim_del_autocmd(g.treesitter_cursormoved)
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

if not g.treesitter_startup then
  g.treesitter_startup = 1
  g.treesitter_cursormoved = a.nvim_create_autocmd({"CursorMoved", "FocusLost"}, {
    callback = function()
      treesitter()
    end,
  })
end
