local M = {}

local f = vim.fn
local c = vim.cmd
local o = vim.opt

local sta

local is_copened = function()
  for i = 1, f['winnr']('$') do
    local bnum = f['winbufnr'](i)
    if f['getbufvar'](bnum, '&buftype') == 'quickfix' then
      return 1
    end
  end
  return nil
end

local nvim_bqf
sta, nvim_bqf = pcall(c, 'packadd nvim-bqf')
if not sta then
  print(nvim_bqf)
  return
end

local bqf
sta, bqf = pcall(require, "bqf")
if sta then
  bqf.setup({
    auto_resize_height = true,
    preview = {
      win_height = 36,
      win_vheight = 36,
      wrap = true,
    },
  })
end

function M.run()
  if is_copened() then
    if o.ft:get() == 'qf' then
      c 'wincmd p'
    end
    c 'ccl'
  else
    c 'copen'
  end
end

return M
