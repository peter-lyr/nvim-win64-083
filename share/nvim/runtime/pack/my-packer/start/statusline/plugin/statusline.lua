local a = vim.api
local f = vim.fn

local statusline_focuslost
local statusline_bufreadpre

local statusline_init = function()
  local timer = vim.loop.new_timer()
  timer:start(100, 100, function()
    vim.schedule(function()
      f['statusline#ro']()
    end)
  end)
  a.nvim_create_autocmd({ 'WinEnter', 'BufEnter', 'VimResized' }, {
    callback = function()
      f['statusline#watch']()
    end,
  })
  a.nvim_create_autocmd({ 'ColorScheme', }, {
    callback = function()
      f['statusline#color']()
    end,
  })
  print('statusline init ok')
end

local del_autocmd = function()
  pcall(a.nvim_del_autocmd, statusline_bufreadpre)
  pcall(a.nvim_del_autocmd, statusline_focuslost)
  statusline_init()
end

statusline_bufreadpre = a.nvim_create_autocmd({ 'BufReadPre' }, {
  pattern = { '*.c', '*.h', '*.lua', '*.py' },
  callback = del_autocmd,
})

statusline_focuslost = a.nvim_create_autocmd({ 'FocusLost' }, {
  callback = del_autocmd,
})
