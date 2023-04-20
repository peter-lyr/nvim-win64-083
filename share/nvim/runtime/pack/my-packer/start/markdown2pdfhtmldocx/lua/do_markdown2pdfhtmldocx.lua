local M = {}

local g = vim.g
local a = vim.api
local f = vim.fn

local sta = nil
local do_terminal = nil

local Path = require("plenary.path")

local path = Path:new(g.markdown2pdfhtmldocx_lua)
path = path:parent():parent()

g.markdown2pdfhtmldocx_py = path:joinpath('autoload', 'main.py')['filename']
g.markdown2pdfhtmldocx_recyclebin_exe = path:joinpath('autoload', 'recyclebin.exe')['filename']

sta, do_terminal = pcall(require, 'do_terminal')
if not sta then
  print(do_terminal)
end

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

local filetypes = {
  'pdf',
  'html',
  'docx',
}

local scandir = function(directory)
  local files = {}
  local result = require("plenary.scandir").scan_dir(directory, { depth = 1, hidden = 1 })
  for _, file in ipairs(result) do
    local extension = file:gsub("^.*%.([^.]+)$", "%1")
    if index_of(filetypes, extension) then
      table.insert(files, file)
    end
  end
  return files
end

local get_dname = function(readablefile)
  if #readablefile == 0 then
    return ''
  end
  local fname = string.gsub(readablefile, "\\", '/')
  path = Path:new(fname)
  if path:is_file() then
    return path:parent()['filename']
  end
  return ''
end

function M.do_markdown2pdfhtmldocx(cmd)
  if cmd == 'create' then
    if do_terminal then
      do_terminal.send_cmd('cmd', 'python ' .. g.markdown2pdfhtmldocx_py .. ' ' .. a['nvim_buf_get_name'](0))
    end
  elseif cmd == 'delete' then
    local curdir = get_dname(a['nvim_buf_get_name'](0))
    curdir = string.gsub(curdir, '/', '\\')
    local files = scandir(curdir)
    local cnt = 0
    for _, v in ipairs(files) do
      cnt = cnt + 1
      local curcmd = g.markdown2pdfhtmldocx_recyclebin_exe .. ' "' .. v .. '"'
      f['system'](curcmd)
    end
    print('delete', cnt, 'file(s)')
  end
end

return M
