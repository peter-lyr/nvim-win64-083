local c = vim.cmd
local f = vim.fn
local g = vim.g
local a = vim.api

local sta

sta, Path = pcall(require, "plenary.path")
if not sta then
  print(Path)
  return
end

local telescope_path = Path:new(g.telescope_lua):parent():parent()

local do_telescope_lua = telescope_path:joinpath('lua', 'do_telescope.lua')['filename']

local add_pack_help = function(plugnames)
  local _sta, _path
  _sta, _path = pcall(require, "plenary.path")
  if not _sta then
    print(_path)
    return nil
  end
  local doc_path
  local packadd
  _path = _path:new(f.expand("$VIMRUNTIME"))
  local opt_path = _path:joinpath('pack', 'packer', 'opt')
  for _, plugname in ipairs(plugnames) do
    doc_path = opt_path:joinpath(plugname, 'doc')
    _sta, packadd = pcall(c, 'packadd ' .. plugname)
    if not _sta then
      print(packadd)
      return nil
    end
    if doc_path:is_dir() then
      c('helptags ' .. doc_path.filename)
    end
  end
  return true
end

if not add_pack_help({ 'telescope.nvim' }) then
  return nil
end


local telescope
sta, telescope = pcall(require, 'telescope')
if not sta then
  print(telescope)
  return
end

local actions
sta, actions = pcall(require, 'telescope.actions')
if not sta then
  print(actions)
  return
end

local actions_layout
sta, actions_layout = pcall(require, 'telescope.actions.layout')
if not sta then
  print(actions_layout)
  return
end

c[[
autocmd User TelescopePreviewerLoaded setlocal number | setlocal wrap
]]

local get_setup_table = function(file_ignore_patterns)
  return {
    defaults = {
      layout_strategy = 'horizontal',
      layout_config = {
        height = 0.99,
        width = 0.99,
      },
      -- preview = {
      --   hide_on_startup = true,
      -- },
      mappings = {
        i = {
          ['<a-m>'] = actions.close,
          ['qm'] = actions.close,
          ['<a-j>'] = actions.move_selection_next,
          ['<a-k>'] = actions.move_selection_previous,
          ['<a-;>'] = actions.send_to_qflist + actions.open_qflist,
          ['<c-j>'] = actions.select_horizontal,
          ['<c-l>'] = actions.select_vertical,
          ['<c-k>'] = actions.select_tab,
          ['<c-o>'] = actions.select_default,
          ['qo'] = actions.select_default,
          ['<a-,>'] = actions.select_default,
          ['<a-n>'] = actions_layout.toggle_preview,
        },
        n = {
          ['ql'] = actions.close,
          ['qm'] = actions.close,
          ['<a-m>'] = actions.close,
          ['<a-j>'] = actions.move_selection_next,
          ['<a-k>'] = actions.move_selection_previous,
          ['<a-;>'] = actions.send_to_qflist + actions.open_qflist,
          ['<c-j>'] = actions.select_horizontal,
          ['<c-l>'] = actions.select_vertical,
          ['<c-k>'] = actions.select_tab,
          ['<c-o>'] = actions.select_default,
          ['o'] = actions.select_default,
          ['<a-,>'] = actions.select_default,
          ['w'] = actions_layout.toggle_preview,
        }
      },
      file_ignore_patterns = file_ignore_patterns,
      vimgrep_arguments = {
        'rg',
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case',
        '--fixed-strings',
      },
      wrap_results = false,
    },
  }
end

telescope.setup(get_setup_table({
  '%.svn',
  '%.vs',
  '%.git',
  '%.cache',
  'obj',
  'build',
  'my%-neovim%-data',
  '%.js',
  '%.asc',
  '%.hex',
  'CMakeLists.txt',
  -- 'map.txt',
  -- '%.lst',
}))


if add_pack_help({ 'aerial.nvim' }) then
  local aerial
  sta, aerial = pcall(telescope.load_extension, "aerial")
  if not sta then
    print(aerial)
  end
end


local projects
sta, projects = pcall(telescope.load_extension, "projects")
if not sta then
  print(projects)
end


local vim_bookmarks
sta, vim_bookmarks = pcall(telescope.load_extension, "vim_bookmarks")
if not sta then
  print(vim_bookmarks)
end


local ui_select
sta, ui_select = pcall(telescope.load_extension, "ui-select")
if not sta then
  print(ui_select)
end


local git_diffs
sta, git_diffs = pcall(telescope.load_extension, "git_diffs")
if not sta then
  print(git_diffs)
end


local M = {}

local do_projects
local do_bookmarks

M.open = function()
  c 'split'
  c('e ' .. do_telescope_lua)
  f.search('telescope.setup' .. '(get_setup_table')
end

local Path = require("plenary.path")
local Scan = require("plenary.scandir")

local split_string = function(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "(.-)" .. sep) do
    table.insert(t, str)
  end
  return t
end

-- local show_array = function(arr)
--   for i, v in ipairs(arr) do
--     print(i, ':', v)
--   end
-- end

local rep = function(path)
  path, _ = string.gsub(path, '/', '\\')
  return path
end

local index_of = function(arr, val)
  if not arr then
    return nil
  end
  for i, v in ipairs(arr) do
    if vim.fn['tolower'](v) == vim.fn['tolower'](val) then
      return i
    end
  end
  return nil
end

local get_sub_dirs = function(dir)
  local path = Path:new(dir)
  local entries = Scan.scan_dir(path.filename, { hidden = false, depth = 50, add_dirs = true })
  local ignored = split_string(f['system']('cd ' .. dir .. ' && git config --local core.quotepath false & git ls-files --other --ignored --exclude-standard --directory'), '\n')
  local cwd_path = Path:new(dir)
  local ignore_dirs = {}
  for _, v in ipairs(ignored) do
    local item = cwd_path:joinpath(v)
    if item:is_dir() then
      local fname = rep(item.filename)
      table.insert(ignore_dirs, string.sub(fname, 1, #fname-1))
    end
  end
  local sub_dirs = {}
  table.insert(sub_dirs, rep(dir))
  for _, entry in ipairs(entries) do
    if Path:new(entry):is_dir() then
      local ignore = nil
      for _, ignore_dir in ipairs(ignore_dirs) do
        if string.find(rep(entry), ignore_dir) then
          ignore = true
          break
        end
      end
      if not ignore then
        table.insert(sub_dirs, rep(entry))
      end
    end
  end
  return sub_dirs
end

M.grep_string = function()
  local cwd = f['getcwd']()
  local sub_dirs = get_sub_dirs(cwd)
  -- show_array(sub_dirs)
  vim.ui.select(sub_dirs, { prompt = 'select one of them' }, function(_, idx)
    -- print(choice, idx)
    local dir = sub_dirs[idx]
    print(dir)
    local cmd = 'Telescope grep_string shorten_path=true word_match=-w only_sort_text=true search= search_dirs=' .. dir
    c(cmd)
  end)
end

M.live_grep = function()
  local cwd = f['getcwd']()
  local sub_dirs = get_sub_dirs(cwd)
  -- show_array(sub_dirs)
  vim.ui.select(sub_dirs, { prompt = 'select one of them' }, function(_, idx)
    -- print(choice, idx)
    local dir = sub_dirs[idx]
    print(dir)
    local cmd = 'Telescope live_grep shorten_path=true word_match=-w only_sort_text=true search= search_dirs=' .. dir
    c(cmd)
  end)
end

local projectroots = {}

local update_projectroots = function(excludecur)
  projectroots = {}
  local curprojectroot = string.gsub(f['projectroot#get'](a.nvim_buf_get_name(0)), '\\', '/')
  for _, bufnr in ipairs(a.nvim_list_bufs()) do
    if f['buflisted'](bufnr) ~= 0 and a.nvim_buf_is_loaded(bufnr) ~= false then
      local projectroot = string.gsub(f['projectroot#get'](a.nvim_buf_get_name(bufnr)), '\\', '/')
      if not index_of(projectroots, projectroot) then
        if excludecur then
          if projectroot ~= curprojectroot then
            table.insert(projectroots, projectroot)
          end
        else
          table.insert(projectroots, projectroot)
        end
      end
    end
  end
end

M.projectsbuffers = function()
  update_projectroots(1)
  vim.ui.select(projectroots, { prompt = 'select one of them' }, function(_, idx)
    local dir = projectroots[idx]
    c('cd ' .. dir)
    local cmd = 'Telescope buffers search_dirs=' .. dir
    c(cmd)
  end)
end

M.projectsbuffersall = function()
  update_projectroots(nil)
  vim.ui.select(projectroots, { prompt = 'select one of them' }, function(_, idx)
    local dir = projectroots[idx]
    c('cd ' .. dir)
    local cmd = 'Telescope buffers search_dirs=' .. dir
    c(cmd)
  end)
end

M.run = function(params)
  if not params or #params == 0 then
    return
  end
  if #params == 1 and params[1] == 'open' then
    M.open()
    return
  end
  if params[1] == 'my' then
    if params[2] == 'grep_string' then
      M.grep_string()
    elseif params[2] == 'live_grep' then
      M.live_grep()
    elseif params[2] == 'projectsbuffers' then
      M.projectsbuffers()
    elseif params[2] == 'projectsbuffersall' then
      M.projectsbuffersall()
    end
    return
  end
  local cmd = table.concat(params, ' ')
  if cmd == 'projects' then
    if not do_projects then
      sta, do_projects = pcall(require, 'do_projects')
      if not sta then
        print(do_projects)
        return
      end
    end
  elseif string.find(cmd, '^vim_bookmarks') then
    if not do_bookmarks then
      sta, do_bookmarks = pcall(require, 'do_bookmarks')
      if not sta then
        print(do_bookmarks)
        return
      end
    end
  end
  c(string.format([[
  try
    Telescope %s
  catch
    echomsg "no %s"
  endtry]], cmd, cmd))
end

return M
