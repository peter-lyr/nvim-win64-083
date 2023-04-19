local f = vim.fn
local a = vim.api

local M = {}

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

local rep = function(path)
  path, _ = string.gsub(path, '/', '\\')
  return path
end

M.run = function(params)
  if not params or #params == 0 then
    return
  end
  local cur_fname = rep(a['nvim_buf_get_name'](0))
  local cur_wnr = f['bufwinnr'](f['bufnr']())
  local ids = {}
  if params[1] == 'cur' then
    for wnr=1, f['winnr']('$') do
      if wnr ~= cur_wnr then
        local bnr = f['winbufnr'](wnr)
        if f['getbufvar'](bnr, '&buftype') ~= 'nofile' then
          local fname = a['nvim_buf_get_name'](bnr)
          fname = string.gsub(fname, '\\', '/')
          if cur_fname == fname then
            table.insert(ids, f['win_getid'](wnr))
          end
        end
      end
    end
    for _, v in ipairs(ids) do
      a['nvim_win_hide'](v)
    end
  else
    local nms = {}
    for wnr=1, f['winnr']('$') do
      local bnr = f['winbufnr'](wnr)
      if f['getbufvar'](bnr, '&buftype') ~= 'nofile' then
        local fname = rep(a['nvim_buf_get_name'](bnr))
        if wnr ~= cur_wnr then
          if index_of(nms, fname) or cur_fname == fname then
            table.insert(ids, f['win_getid'](wnr))
          end
        end
        if not index_of(nms, fname) then
          table.insert(nms, fname)
        end
      end
    end
    for _, v in ipairs(ids) do
      a['nvim_win_hide'](v)
    end
  end
end

return M
