local M = {}

local g = vim.g
local o = vim.opt
local a = vim.api
local f = vim.fn

local sta
local do_terminal
local Path

sta, Path = pcall(require, "plenary.path")
if not sta then
  print(Path)
end

local markdownimage_dir = Path:new(g.markdownimage_lua):parent():parent()['filename']
g.get_clipboard_image_ps1 = Path:new(markdownimage_dir):joinpath('autoload', 'GetClipboardImage.ps1')['filename']

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

function M.getimage(params)
  if #params ~= 2 then
    return
  end
  local sel_jpg, append = unpack(params)
  if do_terminal then
    local fname = a['nvim_buf_get_name'](0)
    local projectroot_path = Path:new(f['projectroot#get'](fname))
    if projectroot_path.filename == '' then
      print([[not projectroot:]], fname)
      return
    end
    local datetime = os.date("%Y%m%d-%H%M%S-")
    local imagetype = sel_jpg == 'sel_jpg' and 'jpg' or 'png'
    local image_name = f['input'](string.format('Input %s image name (no extension needed!): ', imagetype), datetime)
    if #image_name == 0 then
      print('get image canceled!')
      return
    end
    local linenr = f['line']('.')
    local absolute_image_dir_path = projectroot_path:joinpath('saved_images')
    if not absolute_image_dir_path:exists() then
      f['system'](string.format('md "%s"', absolute_image_dir_path.filename))
      print("created ->", rep(absolute_image_dir_path.filename))
    end
    local only_image_name = image_name .. '.' .. imagetype
    local raw_image_path = absolute_image_dir_path:joinpath(only_image_name)
    if raw_image_path:exists() then
      print("existed ->", rep(raw_image_path.filename))
      return
    end
    print("get image ->", rep(raw_image_path.filename))
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
          local sha256 = require("sha2")
          local absolute_image_hash = sha256.sha256(raw_image_data)
          local _md_path = absolute_image_dir_path:joinpath('_.md')
          _md_path:write(
            string.format('![%s-(%d)%s{%s}](%s)\n', only_image_name, #raw_image_data,
              human_readable_fsize(#raw_image_data),
              absolute_image_hash, only_image_name), 'a')
          local reduce_image_path = Path:new(raw_image_path .. '.' .. imagetype)
          local ft = o.ft:get()
          if ft ~= 'markdown' then
            return
          end
          f['system'](string.format('ffmpeg -y -loglevel quiet -i "%s" -q 18 %s', rep(raw_image_path.filename),
            rep(reduce_image_path.filename)))
          local base64
          sta, base64 = pcall(require, 'base64')
          if not sta then
            print('get image: no base64')
            return
          end
          local reduce_image_data = reduce_image_path:_read()
          f['system'](string.format('del "%s"', rep(reduce_image_path.filename)))
          local image_format = sel_jpg == 'sel_jpg' and 'jpeg' or 'png'
          if #reduce_image_data < #raw_image_data then
            local encoded = base64.encode(reduce_image_data)
            if append == 'append' then
              f['append'](linenr,
                string.format('![%s-%s-%s-%s-{%s}](data:image/%s;base64,%s)', only_image_name,
                  human_readable_fsize(#raw_image_data), human_readable_fsize(#reduce_image_data),
                  human_readable_fsize(#encoded), absolute_image_hash, image_format, encoded))
            elseif append == 'no_append' then
              f['append'](linenr,
                string.format('![%s-%s-%s-%s-{%s}]()', only_image_name,
                  human_readable_fsize(#raw_image_data), human_readable_fsize(#reduce_image_data),
                  human_readable_fsize(#encoded), absolute_image_hash))
            end
          else
            local encoded = base64.encode(raw_image_data)
            if append == 'append' then
              f['append'](linenr,
                string.format('![%s-%s-%s-{%s}](data:image/%s;base64,%s)', only_image_name,
                  human_readable_fsize(#raw_image_data), human_readable_fsize(#encoded), absolute_image_hash,
                  image_format,
                  encoded))
            elseif append == 'no_append' then
              f['append'](linenr,
                string.format('![%s-%s-%s-{%s}]()', only_image_name,
                  human_readable_fsize(#raw_image_data), human_readable_fsize(#encoded), absolute_image_hash
                ))
            end
          end
          if timeout > 30 then
            print('get image timeout 3s')
            timer:stop()
          end
        end
      end)
    end)
  end
end

return M
