local a = vim.api
local g = vim.g

local lsp = function()
  if not g.lsp_loaded then
    g.lsp_loaded = 1
    if g.lsp_cursormoved then
      a.nvim_del_autocmd(g.lsp_cursormoved)
    end
    local sta, do_lsp = pcall(require, 'do_lsp')
    if not sta then
      print(do_lsp)
    end
  end
end

if not g.lsp_startup then
  g.lsp_startup = 1
  g.lsp_cursormoved = a.nvim_create_autocmd({"CursorMoved"}, {
    callback = function()
      a.nvim_del_autocmd(g.lsp_cursormoved)
      lsp()
    end,
  })
end
