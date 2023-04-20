local a = vim.api
local c = vim.cmd
local f = vim.fn

local statusline_cursormoved = nil
local statusline_loaded = nil

local statusline = function()
  if not statusline_loaded then
    statusline_loaded = 1
    f['statusline#watch']()
    c [[
        call timer_start(100, 'statusline#timerUpdate', {'repeat' : -1})
        autocmd WinEnter,BufEnter,VimResized * call statusline#watch()
        autocmd ColorScheme * call statusline#color()
      ]]
  end
  f['statusline#color']()
end

local cnt = 0

statusline_cursormoved = a.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'FocusLost' }, {
  callback = function()
    cnt = cnt + 1
    if cnt > 2 then
      a.nvim_del_autocmd(statusline_cursormoved)
    end
    statusline()
  end,
})
