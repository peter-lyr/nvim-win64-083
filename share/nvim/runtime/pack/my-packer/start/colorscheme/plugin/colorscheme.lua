local a = vim.api
local c = vim.cmd

local colorscheme_focuslost
local colorscheme_bufreadpre

local do_colorscheme
local sta

local colorscheme_init = function()
  sta, do_colorscheme = pcall(c, 'colorscheme sierra')
  if not sta then
    print(do_colorscheme)
  else
    print('colorscheme init ok')
  end
end

local del_autocmd = function()
  pcall(a.nvim_del_autocmd, colorscheme_bufreadpre)
  pcall(a.nvim_del_autocmd, colorscheme_focuslost)
  colorscheme_init()
end

colorscheme_bufreadpre = a.nvim_create_autocmd({ 'BufReadPre' }, {
  pattern = { '*.c', '*.h', '*.lua', '*.py' },
  callback = del_autocmd,
})

colorscheme_focuslost = a.nvim_create_autocmd({ 'FocusLost' }, {
  callback = del_autocmd,
})
