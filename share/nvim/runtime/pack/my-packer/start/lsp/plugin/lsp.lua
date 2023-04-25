local a = vim.api

local lsp_focuslost
local lsp_bufreadpre

local do_lsp
local sta

local lsp_init = function()
  sta, do_lsp = pcall(require, 'do_lsp')
  if not sta then
    print(do_lsp)
  else
    print('lsp_init ok')
  end
end

local del_autocmd = function()
  pcall(a.nvim_del_autocmd, lsp_bufreadpre)
  pcall(a.nvim_del_autocmd, lsp_focuslost)
  lsp_init()
end

lsp_bufreadpre = a.nvim_create_autocmd({ 'BufReadPre' }, {
  pattern = { '*.c', '*.h', '*.lua', '*.py' },
  callback = del_autocmd,
})

lsp_focuslost = a.nvim_create_autocmd({ 'FocusLost' }, {
  callback = del_autocmd,
})
