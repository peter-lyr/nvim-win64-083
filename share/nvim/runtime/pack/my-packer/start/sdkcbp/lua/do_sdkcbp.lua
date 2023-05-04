local M = {}

local g = vim.g
local f = vim.fn
local c = vim.cmd
local a = vim.api

M.searched_folders = {}
M.cbp_files = {}

local Path = require("plenary.path")
local Scan = require("plenary.scandir")

local sdkcbp_dir = Path:new(g.sdkcbp_lua):parent():parent()['filename']
g.cmake_app_py = Path:new(sdkcbp_dir):joinpath('autoload', 'cmake_app.py')['filename']
g.cmake_others_py = Path:new(sdkcbp_dir):joinpath('autoload', 'cmake_others.py')['filename']

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
  path, _ = string.gsub(path, '\\', '/')
  return path
end

function M.traverse_folder(project, abspath)
  local path = Path:new(abspath)
  local entries = Scan.scan_dir(path.filename, { hidden = false, depth = 1, add_dirs = true })
  for _, entry in ipairs(entries) do
    local entry_path = Path:new(entry)
    local entry_path_name = rep(entry)
    if entry_path:is_dir() then
      if not index_of(M.searched_folders, entry_path_name) then
        table.insert(M.searched_folders, entry_path_name)
        if string.find(entry_path_name, project) then
          M.traverse_folder(project, entry_path_name)
        end
      end
    else
      if string.match(entry_path_name, '%.([^%.]+)$') == 'cbp' then
        if not index_of(M.cbp_files, entry_path_name) then
          table.insert(M.cbp_files, entry_path_name)
        end
      end
    end
  end
end

function M.find_cbp(dtargets)
  local fname = a['nvim_buf_get_name'](0)
  local path = Path:new(fname)
  if not path:exists() then
    return
  end
  if path:is_file() then
    local dname
    if string.match(fname, '%.([^%.]+)$') == 'cbp' then
      fname = rep(fname)
      table.insert(M.cbp_files, fname)
      return
    else
      dname = path:parent()
    end
    dname = path
    local cnt = 100000
    while 1 do
      for _, dtarget in ipairs(dtargets) do
        local dpath = dname:joinpath(dtarget)
        if dpath:is_dir() then
          M.traverse_folder(M.project, dpath['filename'])
          break
        else
          local fpath = dname:joinpath(dtarget .. '.cbp')
          if fpath:exists() then
            table.insert(M.cbp_files, rep(fpath.filename))
            break
          end
        end
      end
      if M.project == rep(dname.filename) then
        break
      end
      dname = dname:parent()
      if #dname.filename > cnt then
        break
      end
      cnt = #dname.filename
    end
  end
end

function M.split_string(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "(.-)" .. sep) do
    table.insert(t, str)
  end
  return t
end

function M.cmake_app_do(app_cbp)
  print(app_cbp)
  local ll = M.split_string(app_cbp, 'app/projects')
  local mm = table.concat(ll, 'app/projects')
  local nn = string.match(app_cbp, 'app/projects/(.-)/')
  if string.match(app_cbp, 'app/projects') then
    c(string.format([[silent !start cmd /c "chcp 65001 & python "%s" "%s" %s & pause"]], g.cmake_app_py, mm, nn))
  end
end

function M.cmake_app()
  local app_cbp
  if #M.cbp_files == 1 then
    app_cbp = M.cbp_files[1]
    M.cmake_app_do(app_cbp)
  else
    vim.ui.select(M.cbp_files, { prompt = 'select one of them' }, function(_, idx)
      -- print(choice, idx)
      app_cbp = M.cbp_files[idx]
      M.cmake_app_do(app_cbp)
    end)
  end
end

function M.cmake_others()
  local other_cbp = M.cbp_files[1]
  print(other_cbp)
  local path = Path:new(other_cbp)
  c(string.format([[silent !start cmd /c "chcp 65001 & python "%s" "%s" & pause"]], g.cmake_others_py, path:parent().filename))
end

function M.run()
  local fname = a['nvim_buf_get_name'](0)
  M.project = f['projectroot#get'](fname)
  M.project = rep(M.project)
  if #M.project == 0 then
    print('no projectroot:', fname)
  end
  M.cbp_files = {}
  M.searched_folders = {}
  M.find_cbp({ 'app' })
  if #M.cbp_files == 0 then
    M.find_cbp({ 'boot', 'masklib', 'spiloader' })
    if #M.cbp_files == 1 then
      M.cmake_others()
    end
  else
    M.cmake_app()
  end
end

return M
