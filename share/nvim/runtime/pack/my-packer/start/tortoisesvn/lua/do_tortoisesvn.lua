local M = {}

local sta, Path = pcall(require, "plenary.path")
if not sta then
  print(Path)
  return
end

local f = vim.fn
local a = vim.api

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

local system_cd_string = function(absfolder)
  local path = Path:new(absfolder)
  if not path:exists() then
    return ''
  end
  if path:is_file() then
    return string.sub(absfolder, 1, 1) .. ': && cd ' .. absfolder
  end
  return string.sub(absfolder, 1, 1) .. ': && cd ' .. path:parent()['filename']
end

function M.run(cmd, root, yes)
  local path = (root == 'root') and f['projectroot#get'](a['nvim_buf_get_name'](0)) or a['nvim_buf_get_name'](0)
  if yes == 'yes' or index_of({ 'y', 'Y' }, f['trim'](f['input']("Sure to update? [Y/n]: ", 'Y'))) then
    f['execute'](string.format("silent !%s && start tortoiseproc.exe /command:%s /path:\"%s\"", system_cd_string(path),
      cmd, path))
  end
end

return M
