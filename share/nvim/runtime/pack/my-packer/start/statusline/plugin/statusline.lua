local a = vim.api
local c = vim.cmd
local f = vim.fn
local g = vim.g

local statusline = function()
  if not g.statusline_loaded then
    g.statusline_loaded = 1
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

if not g.statusline_startup then
  g.statusline_startup = 1
  g.statusline_cursormoved = a.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "FocusLost" }, {
    callback = function()
      cnt = cnt + 1
      if cnt > 2 then
        a.nvim_del_autocmd(g.statusline_cursormoved)
      end
      statusline()
    end,
  })
end
