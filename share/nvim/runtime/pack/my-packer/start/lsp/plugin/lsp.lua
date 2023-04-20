local a = vim.api

local lsp_loaded = nil
local lsp_cursormoved = nil

local lsp = function()
  if not lsp_loaded then
    lsp_loaded = 1
    a.nvim_del_autocmd(lsp_cursormoved)
    local sta, do_lsp = pcall(require, 'do_lsp')
    if not sta then
      print(do_lsp)
    end
  end
end

lsp_cursormoved = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    lsp()
  end,
})
