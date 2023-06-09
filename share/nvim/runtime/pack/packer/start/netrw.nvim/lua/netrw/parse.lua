local M = {}

M.TYPE_DIR = 0
M.TYPE_FILE = 1
M.TYPE_SYMLINK = 2

function ltrim(s)
  return s:gsub("^%s*(.-)%s*$", "%1")
end

---@alias Word {dir:string, node:string, link:string|nil, extension:string|nil, type:number}

---@param line string
---@return Word|nil
M.get_node = function(line)
  if vim.opt.filetype:get() ~= 'netrw' then
    return nil
  end

  if string.find(line, '^"') then
    return nil
  end

  -- When netrw is empty, there's one line in the buffer and it is empty.
  if line == '' then
    return nil
  end

  local curdir = vim.b.netrw_curdir
  local line = ltrim(line)

  local _, _, node, link = string.find(line, "^(.+)@\t%s*%-%->%s*(.+)")
  if node then
    return {
      dir = curdir,
      node = node,
      link = link,
      type = M.TYPE_SYMLINK,
    }
  end

  local _, _, node = string.find(line, "^([^%s]+)@%s*")
  if node then
    return {
      dir = curdir,
      node = node,
      type = M.TYPE_SYMLINK,
    }
  end

  local _, _, dir = string.find(line, "^([^%s]+)/")
  if dir then
    return {
      dir = curdir,
      node = dir,
      type = M.TYPE_DIR,
    }
  end

  local _, _, file = string.find(line, "^([^%s^%*]+)[%*]*[%s]*")
  return {
    dir = curdir,
    node = file,
    extension = vim.fn.fnamemodify(file, ":e"),
    type = M.TYPE_FILE,
  }
end

return M
