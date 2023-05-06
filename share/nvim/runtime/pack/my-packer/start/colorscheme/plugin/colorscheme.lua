local a = vim.api

local colorscheme_focuslost
local colorscheme_bufreadpre

local do_colorscheme
local sta

-- package.loaded['do_colorscheme'] = nil

local colorscheme_init = function()
  sta, do_colorscheme = pcall(require, 'do_colorscheme')
  if not sta then
    print(do_colorscheme)
  end
end

local del_autocmd = function()
  pcall(a.nvim_del_autocmd, colorscheme_bufreadpre)
  pcall(a.nvim_del_autocmd, colorscheme_focuslost)
  colorscheme_init()
end

colorscheme_bufreadpre = a.nvim_create_autocmd({ 'BufReadPre' }, {
  pattern = { '*.vim', '*.c', '*.h', '*.lua', '*.py' },
  callback = del_autocmd,
})

colorscheme_focuslost = a.nvim_create_autocmd({ 'FocusLost' }, {
  callback = del_autocmd,
})
