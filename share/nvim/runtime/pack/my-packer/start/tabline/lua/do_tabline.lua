local M = {}

local o = vim.opt
local f = vim.fn

local get_fname_tail = function(fname)
  fname = string.gsub(fname, "\\", '/')
  local sta, path = pcall(require, "plenary.path")
  if not sta then
    print('tabline_show no plenary.path')
    return ''
  end
  path = path:new(fname)
  if path:is_file() then
    fname = path:_split()
    return fname[#fname]
  elseif path:is_dir() then
    fname = path:_split()
    if #fname[#fname] > 0 then
      return fname[#fname]
    else
      return fname[#fname - 1]
    end
  end
  return ''
end

M.update_title_string = function()
  local title = get_fname_tail(f['getcwd']())
  if #title > 0 then
    o.titlestring = title
  end
end

return M
