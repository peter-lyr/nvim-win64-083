local a = vim.api

local statusline_focuslost
local statusline_bufreadpre

-- package.loaded['do_statusline'] = nil

local statusline_init = function()
  local sta, do_statusline = pcall(require, 'do_statusline')
  if not sta then
    print(do_statusline)
  end
end

local del_autocmd = function()
  pcall(a.nvim_del_autocmd, statusline_bufreadpre)
  pcall(a.nvim_del_autocmd, statusline_focuslost)
  statusline_init()
end

statusline_bufreadpre = a.nvim_create_autocmd({ 'BufReadPre' }, {
  pattern = { '*.vim', '*.c', '*.h', '*.lua', '*.py' },
  callback = del_autocmd,
})

statusline_focuslost = a.nvim_create_autocmd({ 'FocusLost' }, {
  callback = del_autocmd,
})
