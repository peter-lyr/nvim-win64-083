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
  pcall(c, 'e ' .. M.stack_fpath)
end

function M.open(mode)
  M.split = mode
  open_fpath()
end

function M.copy_fpath()
  M.stack_fpath = a['nvim_buf_get_name'](0)
  print(M.stack_fpath)
end

local ft = {
  'jpg', 'png',
}

local index_of = function(arr, val)
  if not arr then
    return nil
  end
  for i, v in ipairs(arr) do
    if v == val then
      return i
    end
  end
  return nil
end

function M.copy_fpath_silent()
  local fname = a['nvim_buf_get_name'](0)
  if #fname > 0 then
    M.stack_fpath = fname
  end
  pcall(c, 'hide')
  local cur_fname = a.nvim_buf_get_name(0)
  local extension = string.match(cur_fname, '.+%.(%w+)$')
  if index_of(ft, extension) then
    c('bw! ' .. cur_fname)
  end
end

function M.bwunlisted()
  local sta, Path = pcall(require, 'plenary.path')
  if not sta then
    print(Path)
    return
  end
  local bufnrs = vim.tbl_filter(function(b)
    if 1 ~= vim.fn.buflisted(b) then
      local path = Path:new(a.nvim_buf_get_name(b))
      if path:exists() and not path:is_dir() then
        return true
      end
      return false
    end
    return false
  end, vim.api.nvim_list_bufs())
  for _, v in ipairs(bufnrs) do
    c('bw' .. v)
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
  elseif cmd == 'bwunlisted' then
    M.bwunlisted()
  else
    M.open(cmd)
  end
end

return M
