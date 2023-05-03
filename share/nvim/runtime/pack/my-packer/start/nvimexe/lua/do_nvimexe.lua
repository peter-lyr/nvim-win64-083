local f = vim.fn

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

M.run = function(params)
  if not params or #params == 0 then
    return
  end
  if params[1] == 'restart' then
    if index_of({'y', 'Y', 'yes', 'Yes', 'YES'}, f['input']('Sure to restart nvim-qt.exe? ', 'y')) then
      f['system']([[taskkill /f /im nvim.exe]])
    end
  end
end

return M
