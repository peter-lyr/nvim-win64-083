local a = vim.api
local g = vim.g

local treesitter = function()
  if not g.treesitter_loaded then
    g.treesitter_loaded = 1
    a.nvim_del_autocmd(g.treesitter_cursormoved)
    sta, do_treesitter = pcall(require, 'do_treesitter')
    if not sta then
      print("no do_treesitter:", do_treesitter)
      return
    end
  end
  if not do_treesitter then
    return
  end
  do_treesitter.run()
end

if not g.treesitter_startup then
  g.treesitter_startup = 1
  g.treesitter_cursormoved = a.nvim_create_autocmd({"CursorMoved"}, {
    callback = function()
      a.nvim_del_autocmd(g.treesitter_cursormoved)
      treesitter()
    end,
  })
end
