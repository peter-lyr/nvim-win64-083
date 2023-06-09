local M = {}

local g = vim.g
local o = vim.opt
local a = vim.api
local f = vim.fn

local sta
local do_terminal
local Path

local sha256
sta, sha256 = pcall(require, "sha2")
if not sta then
  print(sha256)
  return false
end

sta, Path = pcall(require, "plenary.path")
if not sta then
  print(Path)
  return false
end

local markdownimage_dir = Path:new(g.markdownimage_lua):parent():parent()['filename']
g.get_clipboard_image_ps1 = Path:new(markdownimage_dir):joinpath('autoload', 'GetClipboardImage.ps1')['filename']
g.update_markdown_image_src_py = Path:new(markdownimage_dir):joinpath('autoload', 'update_markdown_image_src.py')
    ['filename']

local pipe_txt_path = Path:new(f['expand']('$TEMP')):joinpath('image_pipe.txt')

sta, do_terminal = pcall(require, 'do_terminal')
if not sta then
  print(do_terminal)
end

local human_readable_fsize = function(sz)
  if sz >= 1073741824 then
    sz = string.format("%.1f", sz / 1073741824.0) .. "G"
  elseif sz >= 10485760 then
    sz = string.format("%d", sz / 1048576) .. "M"
  elseif sz >= 1048576 then
    sz = string.format("%.1f", sz / 1048576.0) .. "M"
  elseif sz >= 10240 then
    sz = string.format("%d", sz / 1024) .. "K"
  elseif sz >= 1024 then
    sz = string.format("%.1f", sz / 1024.0) .. "K"
  else
    sz = sz
  end
  return sz
end

local rep = function(path)
  path, _ = string.gsub(path, '/', '\\')
  return path
end

local rep_reverse = function(path)
  path, _ = string.gsub(path, '\\', '/')
  return path
end

local replace = function(str)
  local arr = {}
  for _ in string.gmatch(str, "[^/]+") do
    table.insert(arr, "..")
  end
  return table.concat(arr, "/")
end

function M.getimage(sel_jpg)
  if do_terminal then
    local fname = a['nvim_buf_get_name'](0)
    local projectroot_path = Path:new(f['projectroot#get'](fname))
    if projectroot_path.filename == '' then
      print('not projectroot:', fname)
      return false
    end
    local datetime = os.date("%Y%m%d-%H%M%S-")
    local imagetype = sel_jpg == 'sel_jpg' and 'jpg' or 'png'
    local image_name = f['input'](string.format('Input %s image name (no extension needed!): ', imagetype), datetime)
    if #image_name == 0 then
      print('get image canceled!')
      return false
    end
    local ft = o.ft:get()
    local cur_winid = f.win_getid()
    local linenr = f['line']('.')
    local absolute_image_dir_path = projectroot_path:joinpath('saved_images')
    if not absolute_image_dir_path:exists() then
      f['system'](string.format('md "%s"', absolute_image_dir_path.filename))
      print("created ->", rep(absolute_image_dir_path.filename))
    end
    local only_image_name = image_name .. '.' .. imagetype
    local raw_image_path = absolute_image_dir_path:joinpath(only_image_name)
    if raw_image_path:exists() then
      print("existed:", rep(raw_image_path.filename))
      return false
    end
    pipe_txt_path:write('', 'w')
    local cmd = string.format('%s "%s" "%s" "%s"', g.get_clipboard_image_ps1, rep(raw_image_path.filename), sel_jpg,
      rep(pipe_txt_path.filename))
    do_terminal.send_cmd('powershell', cmd, 0)
    local timer = vim.loop.new_timer()
    local timeout = 0
    timer:start(100, 100, function()
      vim.schedule(function()
        timeout = timeout + 1
        local pipe_content = pipe_txt_path:_read()
        local find = string.find(pipe_content, 'success')
        if find then
          timer:stop()
          local raw_image_data = raw_image_path:_read()
          print('save one image:', rep(raw_image_path.filename))
          local absolute_image_hash = sha256.sha256(raw_image_data)
          local _md_path = absolute_image_dir_path:joinpath('_.md')
          _md_path:write(
            string.format('![%s-(%d)%s{%s}](%s)\n', only_image_name, #raw_image_data,
              human_readable_fsize(#raw_image_data),
              absolute_image_hash, only_image_name), 'a')
          if ft ~= 'markdown' then
            return false
          end
          local projectroot = rep_reverse(projectroot_path.filename)
          local file_dir = rep_reverse(Path:new(fname):parent().filename)
          local rel = string.sub(file_dir, #projectroot + 1, -1)
          rel = replace(rel)
          local image_rel_path
          if #rel > 0 then
            image_rel_path = rel .. '/saved_images/' .. only_image_name
          else
            image_rel_path = 'saved_images/' .. only_image_name
          end
          if cur_winid ~= f.win_getid() then
            f.win_gotoid(cur_winid)
          end
          f['append'](linenr, string.format('![%s{%s}](%s)', only_image_name, absolute_image_hash, image_rel_path))
        end
        if timeout > 30 then
          print('get image timeout 3s')
          timer:stop()
        end
      end)
    end)
  end
end

local get_saved_images_dirname = function(fname)
  local dir = Path:new(fname):parent()
  local cnt = #dir.filename
  while 1 do
    cnt = #dir.filename
    local path = dir:joinpath('saved_images')
    if path:exists() then
      return dir.filename
    end
    dir = dir:parent()
    if cnt < #dir.filename then
      break
    end
  end
  return nil
end

function M.updatesrc()
  local fname = a.nvim_buf_get_name(0)
  if #fname == 0 then
    print('no fname')
    return
  end
  local saved_images_dirname = get_saved_images_dirname(fname)
  if not saved_images_dirname then
    print('no saved_images dir')
    return
  end
  local cmd = string.format('python %s "%s" "%s"', rep_reverse(g.update_markdown_image_src_py),
    rep_reverse(saved_images_dirname), rep_reverse(fname))
  do_terminal.send_cmd('cmd', cmd, 0)
end

function M.dragimage(sel_jpg, dragimagename)
  local fname = a['nvim_buf_get_name'](0)
  local projectroot_path = Path:new(f['projectroot#get'](fname))
  if projectroot_path.filename == '' then
    print([[not projectroot:]], fname)
    return false
  end
  local datetime = os.date("%Y%m%d-%H%M%S-")
  local imagetype = sel_jpg == 'sel_jpg' and 'jpg' or 'png'
  local image_name = f['input'](string.format('Input %s image name (no extension needed!): ', imagetype), datetime)
  if #image_name == 0 then
    print('get image canceled!')
    return false
  end
  local cur_winid = f.win_getid()
  local linenr = f['line']('.')
  local absolute_image_dir_path = projectroot_path:joinpath('saved_images')
  if not absolute_image_dir_path:exists() then
    f['system'](string.format('md "%s"', absolute_image_dir_path.filename))
    print("created ->", rep(absolute_image_dir_path.filename))
  end
  local only_image_name = image_name .. '.' .. imagetype
  local raw_image_path = absolute_image_dir_path:joinpath(only_image_name)
  if raw_image_path:exists() then
    print("existed:", rep(raw_image_path.filename))
    return false
  end
  f['system'](string.format('copy "%s" "%s"', dragimagename, rep(raw_image_path.filename)))
  local raw_image_data = raw_image_path:_read()
  local absolute_image_hash = sha256.sha256(raw_image_data)
  local _md_path = absolute_image_dir_path:joinpath('_.md')
  _md_path:write(string.format('![%s-(%d)%s{%s}](%s)\n', only_image_name, #raw_image_data,
    human_readable_fsize(#raw_image_data), absolute_image_hash, only_image_name), 'a')
  local projectroot = rep_reverse(projectroot_path.filename)
  local file_dir = rep_reverse(Path:new(fname):parent().filename)
  local rel = string.sub(file_dir, #projectroot + 1, -1)
  rel = replace(rel)
  local image_rel_path
  if #rel > 0 then
    image_rel_path = rel .. '/saved_images/' .. only_image_name
  else
    image_rel_path = 'saved_images/' .. only_image_name
  end
  if cur_winid ~= f.win_getid() then
    f.win_gotoid(cur_winid)
  end
  f['append'](linenr, string.format('![%s{%s}](%s)', only_image_name, absolute_image_hash, image_rel_path))
  print(linenr, string.format('![%s{%s}](%s)', only_image_name, absolute_image_hash, image_rel_path))
end

function M.run(params)
  if #params < 2 then
    return false
  end
  if params[1] == 'getimage' then
    M.getimage(params[2])
  elseif params[1] == 'dragimage' then
    M.dragimage(params[2], params[3])
  elseif params[1] == 'updatesrc' then
    M.updatesrc()
  end
end

return M
