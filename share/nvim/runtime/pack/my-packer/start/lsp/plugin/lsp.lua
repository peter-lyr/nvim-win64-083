local a = vim.api

local lsp_bufreadpre

local sta
local do_lsp

local lsp_init = function()
  sta, do_lsp = pcall(require, 'do_lsp')
  if not sta then
    print(do_lsp)
  end
end

lsp_bufreadpre = a.nvim_create_autocmd({ 'BufReadPre' }, {
  pattern = { '*.c', '*.h', '*.lua', '*.py' },
  callback = function()
    a.nvim_del_autocmd(lsp_bufreadpre)
    lsp_init()
  end,
})
