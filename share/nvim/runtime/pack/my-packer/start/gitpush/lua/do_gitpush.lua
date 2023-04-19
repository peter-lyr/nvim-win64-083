local a = vim.api
local c = vim.cmd
local f = vim.fn
local g = vim.g
local u = vim.ui

local M = {}

local sta, Path = pcall(require, "plenary.path")
if not sta then
  print(Path)
  return
end

local gitpush_path = Path:new(g.gitpush_lua):parent():parent()

M.add_commit = gitpush_path:joinpath('autoload', 'add_commit.bat')['filename']
M.add_commit_push = gitpush_path:joinpath('autoload', 'add_commit_push.bat')['filename']
M.commit_push = gitpush_path:joinpath('autoload', 'commit_push.bat')['filename']
M.git_init = gitpush_path:joinpath('autoload', 'git_init.bat')['filename']
M.just_commit = gitpush_path:joinpath('autoload', 'just_commit.bat')['filename']
M.just_push = gitpush_path:joinpath('autoload', 'just_push.bat')['filename']

local rep = function(path)
  path, _ = string.gsub(path, '\\', '/')
  return path
end

local get_fname_tail = function(fname)
  fname = rep(fname)
  local p5 = Path:new(fname)
  if p5:is_file() then
    fname = p5:_split()
    return fname[#fname]
  elseif p5:is_dir() then
    fname = p5:_split()
    if #fname[#fname] > 0 then
      return fname[#fname]
    else
      return fname[#fname - 1]
    end
  end
  return ''
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

function M.run(params)
  if not params or #params == 0 then
    return
  end
  local cmd = params[1]
  if cmd == "add_commit" then
    cc = M.add_commit
  elseif cmd == "add_commit_push" then
    cc = M.add_commit_push
  elseif cmd == "commit_push" then
    cc = M.commit_push
  elseif cmd == "git_init" then
    cc = M.git_init
  elseif cmd == "just_commit" then
    cc = M.just_commit
  elseif cmd == "just_push" then
    cc = M.just_push
  end
  if cmd == "git_init" then
    local fname = a['nvim_buf_get_name'](0)
    local p1 = Path:new(fname)
    if not p1:is_file() then
      c 'ec "not file"'
      return
    end
    if not g.loaded_config_telescope then
      local exe_telescope
      sta, exe_telescope = pcall(require, 'exe_telescope')
      if not sta then
        print("no exe_telescope")
        return
      end
      exe_telescope.exe_telescope('')
    end
    local d = {}
    for _ = 1, 24 do
      p1 = p1:parent()
      local name = p1['filename']
      name = rep(name)
      table.insert(d, name)
      if not string.match(name, '/') then
        break
      end
    end
    u.select(d, { prompt = 'git init' }, function(choice)
      if not choice then
        return
      end
      local dpath = choice
      local remote_dname = get_fname_tail(dpath)
      if remote_dname == '' then
        return
      end
      remote_dname = '.git-' .. remote_dname
      f['system'](string.format('cd %s && start cmd /c "%s %s"', dpath, cc, remote_dname))
      fname = dpath .. '/.gitignore'
      local p3 = Path.new(fname)
      if p3:is_file() then
        local lines = f['readfile'](fname)
        if not index_of(lines, remote_dname) then
          f['writefile']({ remote_dname }, fname, "a")
        end
      else
        f['writefile']({ remote_dname }, fname, "a")
      end
    end)
  else
    f['system'](string.format('cd %s && start cmd /c "%s"', Path:new(a['nvim_buf_get_name'](0)):parent()['filename'], cc))
  end
end

return M
