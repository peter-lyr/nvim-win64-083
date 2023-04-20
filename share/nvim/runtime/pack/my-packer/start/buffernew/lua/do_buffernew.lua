local a = vim.api
local c = vim.cmd

local M = {}

local open_fpath = function()
  if M.split == 'up' then
    c 'leftabove split'
  elseif M.split == 'right' then
    c 'rightbelow vsplit'
  elseif M.split == 'down' then
    c 'rightbelow split'
  elseif M.split == 'left' then
    c 'leftabove vsplit'
  end
  c('e ' .. M.stack_fpath)
end

function M.open(mode)
  M.split = mode
  open_fpath()
end

function M.copy_fpath()
  M.stack_fpath = a['nvim_buf_get_name'](0)
  print(M.stack_fpath)
end

function M.copy_fpath_silent()
  local fname = a['nvim_buf_get_name'](0)
  if #fname > 0 then
    M.stack_fpath = fname
  end
end

M.run = function(params)
  if not params or #params == 0 then
    return
  end
  local cmd = params[1]
  if cmd == 'copy_fpath' then
    M.copy_fpath()
  elseif cmd == 'copy_fpath_silent' then
    M.copy_fpath_silent()
  else
    M.open(cmd)
  end
end

return M
