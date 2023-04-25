local a = vim.api

local cmp_focuslost
local cmp_bufreadpre

local do_cmp
local sta

local cmp_init = function()
  sta, do_cmp = pcall(require, 'do_cmp')
  if not sta then
    print(do_cmp)
  end
end

local del_autocmd = function()
  pcall(a.nvim_del_autocmd, cmp_bufreadpre)
  pcall(a.nvim_del_autocmd, cmp_focuslost)
  cmp_init()
end

cmp_bufreadpre = a.nvim_create_autocmd({ 'InsertEnter' }, {
  pattern = { '*.c', '*.h', '*.lua', '*.py' },
  callback = del_autocmd,
})

cmp_focuslost = a.nvim_create_autocmd({ 'FocusLost' }, {
  callback = del_autocmd,
})
