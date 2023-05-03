local sta, netrw = pcall(require, 'netrw')
if not sta then
  print(netrw)
  return
end

local a = vim.api
local b = vim.b
local c = vim.cmd
local f = vim.fn
local g = vim.g
local o = vim.opt
local w = vim.w

local Path = require("plenary.path")
local Scan = require("plenary.scandir")

local p = Path:new(g.netrw_lua)
g.netrw_recyclebin = p:parent():parent():joinpath('autoload', 'recyclebin.exe').filename
g.copy2clip = p:parent():parent():joinpath('autoload', 'copy2clip.exe').filename

local rep = function(path)
  path, _ = string.gsub(path, '\\\\', '/')
  path, _ = string.gsub(path, '\\', '/')
  return path
end

local get_dname = function(payload)
  f['netrw#Call']("NetrwBrowseChgDir", 1, f['netrw#Call']("NetrwGetWord"), 1)
  if not payload or payload['type'] == 0 then
    local res = f['netrw#Call']("NetrwBrowseChgDir", 1, f['netrw#Call']("NetrwGetWord"), 1)
    if #res > 0 then
      return string.gsub(res, "/", "\\")
    end
  end
  return ''
end

local get_fname = function(payload)
  f['netrw#Call']("NetrwBrowseChgDir", 1, f['netrw#Call']("NetrwGetWord"), 1)
  if payload and payload['type'] == 1 then
    local res = f['netrw#Call']("NetrwBrowseChgDir", 1, f['netrw#Call']("NetrwGetWord"), 1)
    if #res > 0 then
      return string.gsub(res, "/", "\\")
    end
  end
  return ''
end

local get_fname_tail = function(fname)
  fname = string.gsub(fname, "/", "\\")
  local path = Path:new(fname)
  if path:is_file() then
    fname = path:_split()
    return fname[#fname]
  elseif path:is_dir() then
    fname = path:_split()
    if #fname[#fname] > 0 then
      return fname[#fname]
    else
      return fname[#fname - 1]
    end
  end
  return ''
end

local get_dtarget = function(payload)
  local fname
  local dname = get_dname(payload)
  if #dname > 0 then
    dname = string.gsub(dname, "/", "\\")
    return dname
  end
  fname = get_fname(payload)
  fname = string.gsub(fname, "/", "\\")
  local path = Path:new(fname)
  if path:is_file() then
    fname = path:parent().filename
    fname = string.gsub(fname, "/", "\\")
    return fname .. '\\'
  end
  return ''
end

local test = function(payload)
  -- - dir: the current netrw directory (vim.b.netrw_curdir)
  -- - node: the name of the file or directory under the cursor
  -- - link: the referenced file if the node under the cursor is a symlink
  -- - extension: the file extension if the node under the cursor is a file
  -- - type: the type of node under the cursor (0 = dir, 1 = file, 2 = symlink)
  -- print(vim.inspect(payload))
  print('node:', payload.node)
  print('fname:', get_fname(payload))
  print('dname:', get_dname(payload))
  print('dtarg:', get_dtarget(payload))
end

local preview = function(payload)
  if not payload or b.netrw_liststyle == 2 then
    return nil
  end
  if o.ft:get() ~= 'netrw' then
    return nil
  end
  if payload['type'] == 1 then
    local fname = get_fname(payload)
    if f['filereadable'](fname) then
      f['netrw#Call']("NetrwPreview", fname)
      return 1
    end
  else
    c [[ call feedkeys("\<cr>") ]]
  end
  return nil
end

local preview_go = function(payload)
  if preview(payload) then
    c [[ wincmd p ]]
  end
end

local is_winfixwidth = function()
  if o.winfixwidth:get() then
    return 1
  end
  return nil
end

local get_win_cnt_no_scratch = function()
  local wnrs = {}
  for i = 1, f['winnr']('$') do
    if f['getbufvar'](f['winbufnr'](i), '&buftype') ~= 'nofile' then
      table.insert(wnrs, i)
    end
  end
  if #wnrs == 0 then
    return nil
  end
  return wnrs
end

local is_hide_en = function()
  local cnt = 0
  for i = 1, f['winnr']('$') do
    if f['getbufvar'](f['winbufnr'](i), '&buftype') ~= 'nofile' then
      cnt = cnt + 1
    end
    if cnt > 1 then
      return true
    end
  end
  return false
end

local open = function(payload, direction)
  if not payload then
    return
  end
  if payload['type'] == 0 then
    c [[ call feedkeys("\<cr>") ]]
    return
  end
  local fname = get_fname(payload)
  if direction == 'tab' then
    c [[ tabnew ]]
  else
    if is_winfixwidth() then
      local cur_winid = f['win_getid']()
      local wnrs = get_win_cnt_no_scratch()
      if not wnrs then
        print('2--23-23-23-423-4')
        return
      end
      if #wnrs == 1 then
        c [[ wincmd v ]]
        c(string.format("e %s", fname))
        return
      else
        if f['win_gotoid'](g.netrw_back_winid) == 0 then
          print('23423J4J')
        end
      end
      a.nvim_win_set_width(cur_winid, 0)
    end
    if o.ft:get() == 'netrw' then
      if is_hide_en() then
        c 'hide'
      end
      if f['win_gotoid'](g.netrw_back_winid) == 0 then
        print('99999j4j')
      end
    end
    if direction == 'up' then
      c [[ leftabove new ]]
    elseif direction == 'down' then
      c [[ new ]]
    elseif direction == 'left' then
      c [[ leftabove vnew ]]
    elseif direction == 'right' then
      c [[ vnew ]]
    end
  end
  c(string.format("e %s", fname))
end

local updir = function()
  c [[ call feedkeys("-") ]]
end

local copy_fname = function(payload)
  if not payload then
    return
  end
  if payload['type'] == 0 then
    local dname = get_fname_tail(get_dname(payload))
    c(string.format([[let @+ = "%s"]], dname))
    print(dname)
  else
    local fname = get_fname_tail(get_fname(payload))
    c(string.format([[let @+ = "%s"]], fname))
    print(fname)
  end
end

local copy_fname_full = function(payload)
  if not payload then
    return
  end
  if payload['type'] == 0 then
    local dname = get_dname(payload)
    c(string.format([[let @+ = '%s']], dname))
    print(dname)
  else
    local fname = get_fname(payload)
    c(string.format([[let @+ = '%s']], fname))
    print(fname)
  end
end

local toggle_dir = function(payload)
  if not payload or b.netrw_liststyle == 2 then
    return nil
  end
  if o.ft:get() ~= 'netrw' then
    return nil
  end
  if payload['type'] == 0 then
    c [[ call feedkeys("\<cr>") ]]
  end
end

local preview_file = function(payload)
  if not payload or b.netrw_liststyle == 2 then
    return nil
  end
  if o.ft:get() ~= 'netrw' then
    return nil
  end
  local fname = get_fname(payload)
  if payload['type'] == 1 then
    if f['filereadable'](fname) then
      f['netrw#Call']("NetrwPreview", fname)
      return 1
    end
  end
end

local chg_dir = function(payload)
  if not payload then
    return
  end
  c(string.format("cd %s", get_dtarget(payload)))
  print(f['getcwd']())
end

local explorer = function(payload)
  if not payload then
    return
  end
  f['system'](string.format("cd %s && start .", get_dtarget(payload)))
end

local system_start = function(payload)
  if not payload then
    return
  end
  if payload['type'] == 1 then
    f['system'](string.format([[start /b /min cmd /c "%s"]], get_fname(payload)))
  else
    f['system'](string.format("start %s", get_dname(payload)))
  end
end

local ignore_list = {
  '.git/',
  '.svn/',
}

local hide = function()
  local netrw_list_hide = table.concat(ignore_list, ',')
  local netrw_list_hide2 = string.gsub(
  string.gsub(
  f['system']('cd ' ..
  f['netrw#Call']('NetrwGetCurdir', 1) ..
  ' && git config --local core.quotepath false & git ls-files --other --ignored --exclude-standard --directory'), '\n',
  ','), ',$', '')
  if #netrw_list_hide2 > 0 then
    netrw_list_hide = netrw_list_hide .. ',' .. netrw_list_hide2
  end
  if netrw_list_hide ~= g.netrw_list_hide then
    g.netrw_list_hide = netrw_list_hide
    if w.netrw_liststyle < 2 and g.netrw_hide == 1 then
      c([[call feedkeys("..")]])
    end
  end
  f['netrw#Call']("NetrwHide", 1)
end

local go_dir = function(payload)
  if not payload then
    return
  end
  c(string.format("Explore %s", get_dtarget(payload)))
end

local unfold_all = function(start)
  if w.netrw_liststyle ~= 3 then
    return
  end
  local lnr0 = (start == 0 or start == 3) and 0 or f['line']('.')
  local lnr00 = f['line']('.')
  local lnr = lnr0 - 1
  local only_one = start == 2 and true or false
  local only_one_go = false
  local all = start == 3 and true or false
  local _, space_cnt0 = string.find(f['getline'](lnr + 1), '(%s+)')
  local cnt = 0
  while 1 do
    if lnr == f['line']('$') then
      break
    end
    lnr = lnr + 1
    local line = f['getline'](lnr)
    if string.sub(line, 1, 1) == '"' or string.sub(line, 1, 2) == './' then
      goto continue
    end
    if string.sub(line, 1, 3) == '../' then
      lnr = lnr + 1
      goto continue
    end
    local _, space_cnt = string.find(line, '(%s+)')
    if not space_cnt then
      goto continue
    end
    if string.sub(line, #line, #line) == '/' then
      local unfold = false
      if lnr == f['line']('$') then
        if only_one and space_cnt <= space_cnt0 then
          if only_one_go then
            c(string.format([[norm %dgg]], lnr00))
            return
          end
          only_one_go = true
        end
        unfold = true
      end
      if unfold == false then
        local has_space, _ = string.find(line, '(%s+)')
        if has_space and has_space > 1 then
          goto continue
        else
          if only_one and space_cnt <= space_cnt0 then
            if only_one_go then
              c(string.format([[norm %dgg]], lnr00))
              return
            end
            only_one_go = true
          end
          local line_down = f['getline'](lnr + 1)
          local _, space_cnt_down = string.find(line_down, '(%s+)')
          if space_cnt >= space_cnt_down then
            unfold = true
          end
        end
      end
      if unfold then
        c(string.format('norm %dgg', lnr))
        local res = get_dname({ type = 0 })
        if #res > 0 then
          res = string.gsub(res, '\\', '/')
        end
        f['netrw#LocalBrowseCheck'](res)
        if not all then
          cnt = cnt + 1
          if cnt > 10 then
            c [[ec 'unfold 10']]
            c(string.format([[norm %dgg]], lnr00))
            return
          end
        end
      end
    end
    ::continue::
  end
  c(string.format([[norm %dgg]], lnr00))
end

local fold_all = function()
  if w.netrw_liststyle ~= 3 then
    return
  end
  local lnr = 0
  while 1 do
    if lnr == f['line']('$') then
      break
    end
    lnr = lnr + 1
    local line = f['getline'](lnr)
    if string.sub(line, 1, 1) == '"' or string.sub(line, 1, 2) == './' then
      goto continue
    end
    if string.sub(line, 1, 3) == '../' then
      lnr = lnr + 1
      goto continue
    end
    if string.sub(line, #line, #line) == '/' then
      if lnr == f['line']('$') then
        return
      end
      local has_space, _ = string.find(line, '(%s+)')
      if has_space > 1 then
        goto continue
      else
        local _, space_cnt = string.find(line, '(%s+)')
        if space_cnt == 2 then
          local line_down = f['getline'](lnr + 1)
          local _, space_cnt_down = string.find(line_down, '(%s+)')
          if space_cnt_down == 4 then
            c(string.format('norm %dgg', lnr))
            f['netrw#LocalBrowseCheck'](f['netrw#Call']("NetrwBrowseChgDir", 1, f['netrw#Call']("NetrwGetWord"), 1))
          end
        end
      end
    end
    ::continue::
  end
end

local go_parent = function()
  if w.netrw_liststyle ~= 3 then
    return
  end
  local lnr0 = f['line']('.')
  local line0 = f['getline'](lnr0)
  local has_space, _ = string.find(line0, '(%s+)')
  if has_space > 1 then
    return
  end
  local _, space_cnt0 = string.find(line0, '(%s+)')
  for i = lnr0 - 1, 1, -1 do
    local line = f['getline'](i)
    local _, space_cnt = string.find(line, '(%s+)')
    if space_cnt and space_cnt < space_cnt0 then
      c(string.format([[norm %dgg]], i))
      return
    end
  end
end

local go_sibling = function(dir)
  if w.netrw_liststyle ~= 3 then
    return
  end
  local lnr0 = f['line']('.')
  local line0 = f['getline'](lnr0)
  local has_space, _ = string.find(line0, '(%s+)')
  if has_space > 1 then
    return
  end
  local _, space_cnt0 = string.find(line0, '(%s+)')
  if dir == 'up' then
    for i = lnr0 - 1, 1, -1 do
      local line = f['getline'](i)
      local _, space_cnt = string.find(line, '(%s+)')
      if not space_cnt then
        return
      end
      if space_cnt == space_cnt0 then
        c(string.format([[norm %dgg]], i))
        return
      end
    end
  else
    for i = lnr0 + 1, f['line']('$') do
      local line = f['getline'](i)
      local _, space_cnt = string.find(line, '(%s+)')
      if not space_cnt then
        return
      end
      if space_cnt == space_cnt0 then
        c(string.format([[norm %dgg]], i))
        return
      end
    end
  end
end

local search_fname = function(dir)
  c(string.format([[call search("%s", "%s")]], g.netrw_alt_fname, dir == 'up' and 'b' or ''))
end

g.netrw_sel_list = {}
g.netrw_sel_list_bak = {}

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

local appendIfNotExists = function(t, s)
  local idx = index_of(t, s)
  local cwd = f['getcwd']()
  if not idx then
    table.insert(t, s)
    c(string.format([[ec 'attach: %s']], string.sub(s, #cwd + 2, #s)))
  else
    table.remove(t, idx)
    s = string.gsub(s, f['getcwd'](), '')
    c(string.format([[ec 'detach: %s']], string.sub(s, #cwd + 2, #s)))
  end
  return t
end

local sel_toggle_cur = function(payload)
  if not payload then
    return
  end
  local name = get_fname(payload)
  if name == '' then
    name = get_dname(payload)
  end
  g.netrw_sel_list = appendIfNotExists(g.netrw_sel_list, name)
  c 'norm j'
end

local sel_toggle_all = function()
  if not g.netrw_sel_list or #g.netrw_sel_list == 0 then
    g.netrw_sel_list = g.netrw_sel_list_bak
    local show_array = function(arr)
      for i, v in ipairs(arr) do
        c(string.format([[ec '%d : %s']], i, v))
      end
    end
    show_array(g.netrw_sel_list)
  else
    c(string.format('ec "empty %d"', #g.netrw_sel_list))
    g.netrw_sel_list_bak = g.netrw_sel_list
    g.netrw_sel_list = {}
  end
end

local sel_all = function(payload)
  if not payload then
    return
  end
  local target = get_dname(payload)
  if #target == 0 then
    target = get_fname(payload)
  end
  local path = Path:new(target)
  target = path:parent().filename
  target = string.gsub(target, "/", "\\")
  local scandir = require "plenary.scandir"
  local result = scandir.scan_dir(target, { depth = 1, hidden = 1, add_dirs = 1 })
  print(target)
  if #g.netrw_sel_list == 0 then
    g.netrw_sel_list_bak = {}
    for _, file in ipairs(result) do
      file, _ = string.gsub(file, '\\\\', '\\')
      g.netrw_sel_list = appendIfNotExists(g.netrw_sel_list, file)
    end
  else
    sel_toggle_all()
  end
end

local empty_sel_list = function()
  g.netrw_sel_list = {}
  g.netrw_sel_list_bak = {}
end

local delete_sel_list = function()
  local res = f['input']("Confirm deletion " .. #g.netrw_sel_list .. " [N/y] ", "y")
  if index_of({ 'y', 'Y', 'yes', 'Yes', 'YES' }, res) then
    for _, v in ipairs(g.netrw_sel_list) do
      -- if Path:new(v):is_dir() then
      --   f['system'](string.format('rd /s /q "%s"', v))
      -- else
      --   f['system'](string.format('del "%s"', v))
      -- end
      local path = Path:new(v)
      if path:is_dir() then
        local entries = Scan.scan_dir(v, { hidden = true, depth = 10, add_dirs = false })
        for _, entry in ipairs(entries) do
          pcall(c, "bw! " .. rep(entry))
        end
      else
        pcall(c, "bw! " .. rep(v))
      end
      f['system'](string.format('%s "%s"', g.netrw_recyclebin, v:match('^(.-)\\*$')))
    end
    f['netrw#Call']("NetrwRefresh", 1, f['netrw#Call']("NetrwBrowseChgDir", 1, './'))
    empty_sel_list()
  else
    print('canceled!')
  end
end

local move_sel_list = function(payload)
  local target = get_dtarget(payload)
  local res = f['input'](target .. "\nConfirm movment " .. #g.netrw_sel_list .. " [N/y] ", "y")
  if index_of({ 'y', 'Y', 'yes', 'Yes', 'YES' }, res) then
    for _, v in ipairs(g.netrw_sel_list) do
      if Path:new(v):is_dir() then
        local dname = get_fname_tail(v)
        dname = string.format('%s%s', target, dname)
        if Path:new(dname):exists() then
          c'redraw'
          local dname_new = f['input'](v .. " ->\nExisted! Rename? ", dname)
          if #dname_new > 0 and dname_new ~= dname then
            f['system'](string.format('move "%s" "%s"', string.sub(v, 1, #v - 1), dname_new))
          elseif #dname_new == 0 then
            print('cancel all!')
            return
          else
            c'redraw'
            print(v .. ' -> failed!')
            goto continue
          end
        else
          f['system'](string.format('move "%s" "%s"', string.sub(v, 1, #v - 1), dname))
        end
      else
        local fname = get_fname_tail(v)
        fname = string.format('%s%s', target, fname)
        if Path:new(fname):exists() then
          c'redraw'
          local fname_new = f['input'](v .. " ->\nExisted! Rename? ", fname)
          if #fname_new > 0 and fname_new ~= fname then
            f['system'](string.format('move "%s" "%s"', v, fname_new))
          elseif #fname_new == 0 then
            print('cancel all!')
            return
          else
            c'redraw'
            print(v .. ' -> failed!')
            goto continue
          end
        else
          f['system'](string.format('move "%s" "%s"', v, fname))
        end
      end
      pcall(c, "bw! " .. rep(v))
      ::continue::
    end
    empty_sel_list()
    f['netrw#Call']("NetrwRefresh", 1, f['netrw#Call']("NetrwBrowseChgDir", 1, './'))
  else
    print('canceled!')
  end
end

local copy_sel_list = function(payload)
  local target = get_dtarget(payload)
  local res = f['input'](target .. "\nConfirm copy " .. #g.netrw_sel_list .. " [N/y] ", "y")
  if index_of({ 'y', 'Y', 'yes', 'Yes', 'YES' }, res) then
    for _, v in ipairs(g.netrw_sel_list) do
      if Path:new(v):is_dir() then
        local dname = get_fname_tail(v)
        dname = string.format('%s%s', target, dname)
        if Path:new(dname):exists() then
          c'redraw'
          local dname_new = f['input'](v .. " ->\nExisted! Rename? ", dname)
          if #dname_new > 0 and dname_new ~= dname then
            if string.sub(dname_new, #dname_new, #dname_new) ~= '\\' then
              dname_new = dname_new .. '\\'
            end
            f['system'](string.format('xcopy "%s" "%s" /s /e /f', v, dname_new))
          elseif #dname_new == 0 then
            print('cancel all!')
            return
          else
            c'redraw'
            print(v .. ' -> failed!')
            goto continue
          end
        else
          if string.sub(dname, #dname, #dname) ~= '\\' then
            dname = dname .. '\\'
          end
          f['system'](string.format('xcopy "%s" "%s" /s /e /f', v, dname))
        end
      else
        local fname = get_fname_tail(v)
        fname = string.format('%s%s', target, fname)
        if Path:new(fname):exists() then
          c'redraw'
          local fname_new = f['input'](v .. "\n ->Existed! Rename? ", fname)
          if #fname_new > 0 and fname_new ~= fname then
            f['system'](string.format('copy "%s" "%s"', v, fname_new))
          elseif #fname_new == 0 then
            print('cancel all!')
            return
          else
            c'redraw'
            print(v .. ' -> failed!')
            goto continue
          end
        else
          f['system'](string.format('copy "%s" "%s"', v, fname))
        end
      end
      f['netrw#Call']("NetrwRefresh", 1, f['netrw#Call']("NetrwBrowseChgDir", 1, './'))
      ::continue::
    end
    empty_sel_list()
  else
    print('canceled!')
  end
end

local temppath = Path:new(f['expand']('$temp'))

local rename_sel_list = function()
  local lines = {}
  for _, v in ipairs(g.netrw_sel_list) do
    if not Path:new(v):is_dir() then
      table.insert(lines, v)
    end
  end
  for _, v in ipairs(g.netrw_sel_list) do
    if Path:new(v):is_dir() then
      table.insert(lines, v)
    end
  end
  c('hide')
  c('new')
  local diff1 = f['bufnr']()
  c('set noro')
  c('set ma')
  f['setline'](1, lines)
  c('diffthis')
  c('set ro')
  c('set noma')
  c('vnew')
  local diff2 = f['bufnr']()
  c('set noro')
  c('set ma')
  f['setline'](1, lines)
  c('diffthis')
  c('call feedkeys("zR$")')
  local timer = vim.loop.new_timer()
  local tmp1 = 0
  local pattern = "^[:\\/%w%s%-%._%(%)%[%]一-龥]+$"
  timer:start(100, 100, function()
    vim.schedule(function()
      if (f['bufwinnr'](diff1) == -1 or f['bufwinnr'](diff2) == -1) then
        if f['bufwinnr'](diff1) == -1 and f['bufwinnr'](diff2) == -1 then
          tmp1 = tmp1 + 1
          if tmp1 > 10 * 60 * 5 then
            timer:stop()
            pcall(c, diff1 .. 'bw!')
            pcall(c, diff2 .. 'bw!')
            print('canceled!')
          end
          return
        end
        timer:stop()
        local lines1 = f['getbufline'](diff1, 1, '$')
        local lines2 = f['getbufline'](diff2, 1, '$')
        local cnt1 = 0
        local cnt2 = 0
        for _, v in ipairs(lines1) do
          if #f['trim'](v) > 0 and string.match(v, pattern) then
            cnt1 = cnt1 + 1
          end
        end
        for _, v in ipairs(lines2) do
          if #f['trim'](v) > 0 and string.match(v, pattern) then
            cnt2 = cnt2 + 1
          end
        end
        if cnt1 ~= cnt2 then
          pcall(c, diff1 .. 'bw!')
          pcall(c, diff2 .. 'bw!')
          print(cnt1, '~=', cnt2)
          return
        end
        local cnt = 1
        local cmds = {}
        for _, v in ipairs(lines1) do
          local v1 = f['trim'](v)
          if #v1 > 0 and string.match(v1, pattern) then
            local v1path = Path:new(v1)
            if v1path:is_dir() then
              if string.sub(v1, #v1, #v1) ~= '\\' then
                cmds[cnt] = {0, v1 .. '\\'}
              else
                cmds[cnt] = {0, v1}
              end
            else
              cmds[cnt] = {1, v1}
            end
            cnt = cnt + 1
          end
        end
        for k, v in pairs(cmds) do
          local is_file = v[1]
          local src = v[2]
          src = string.gsub(src, '[/\\:]', '_')
          src = temppath:joinpath(src).filename
          if is_file == 0 then
            table.insert(cmds[k], src .. '\\')
          else
            table.insert(cmds[k], src)
          end
        end
        cnt = 1
        for _, v in ipairs(lines2) do
          local v1 = f['trim'](v)
          if #v1 > 0 and string.match(v1, pattern) then
            local is_file = cmds[cnt][1]
            if is_file == 0 then
              if string.sub(v1, #v1, #v1) ~= '\\' then
                table.insert(cmds[cnt], v1 .. '\\')
              else
                table.insert(cmds[cnt], v1)
              end
            else
              table.insert(cmds[cnt], v1)
            end
            cnt = cnt + 1
          end
        end
        for _, v in pairs(cmds) do
          local s1 = v[2]
          local s2 = v[3]
          if v[1] == 0 then
            s1 = string.sub(v[2], 0, #v[2]-1)
            s2 = string.sub(v[3], 0, #v[3]-1)
          end
          f['system'](string.format('move "%s" "%s"', s1, s2))
        end
        for _, v in pairs(cmds) do
          local s2 = v[3]
          local s3 = v[4]
          if v[1] == 0 then
            s2 = string.sub(v[3], 0, #v[3]-1)
            s3 = string.sub(v[4], 0, #v[4]-1)
          end
          f['system'](string.format('move "%s" "%s"', s2, s3))
        end
        pcall(c, diff1 .. 'bw!')
        pcall(c, diff2 .. 'bw!')
        empty_sel_list()
      end
    end)
  end)
end

local copy_2_clip = function()
  local files = ""
  for _, v in ipairs(g.netrw_sel_list) do
    files = files .. " " .. '"' .. v .. '"'
  end
  f['system'](string.format('%s%s', g.copy2clip, files))
end

local create = function(payload)
  local name = get_fname(payload)
  if name == '' then
    name = get_dname(payload)
  end
  c(string.format([[call feedkeys(":wincmd p|wincmd s|e %s")]], string.gsub(name, "\\", "/")))
end

local createmulti = function(payload)
  local dtarget = get_dtarget(payload)
  c(string.format("echo '%s'", dtarget))
  local res = f['input']("Create multiple files: ", "aaa bbb ccc ddd")
  local t1 = f['split'](res, ' ')
  local a1 = nil
  for _, fname in ipairs(t1) do
    if string.match(fname, "^[%w%s%-%._%(%)%[%]一-龥]+$") ~= nil then
      c(string.format([[call writefile([], '%s')]], dtarget .. fname))
    else
      a1 = true
      print('failed: ' .. fname)
    end
  end
  f['netrw#Call']("NetrwRefresh", 1, f['netrw#Call']("NetrwBrowseChgDir", 1, './'))
  if a1 then
    print('只允许字母、数字、空格、连字符、下划线、点号、括号、方括号和中文字符出现')
  end
end

local create_dir = function(payload)
  local dtarget = get_dtarget(payload)
  c(string.format([[call feedkeys(':silent !cd "%s" && md ')]], string.gsub(dtarget, "/", "\\")))
end

local create_dirmulti = function(payload)
  local dtarget = get_dtarget(payload)
  c(string.format("echo '%s'", dtarget))
  local res = f['input']("Create multiple dirs: ", "aaa bbb ccc ddd")
  local t1 = f['split'](res, ' ')
  local a1 = nil
  for _, fname in ipairs(t1) do
    if string.match(fname, "^[%w%s%-%._%(%)%[%]一-龥]+$") ~= nil then
      c(string.format([[call mkdir('%s')]], dtarget .. fname))
    else
      a1 = true
      print('failed: ' .. fname)
    end
  end
  f['netrw#Call']("NetrwRefresh", 1, f['netrw#Call']("NetrwBrowseChgDir", 1, './'))
  if a1 then
    print('只允许字母、数字、空格、连字符、下划线、点号、括号、方括号和中文字符出现')
  end
end

local delete = function(payload)
  if not payload then
    return
  end
  local dtarget = get_dtarget(payload)
  if payload.type == 0 then
    local dtargetpath = Path:new(dtarget)
    local entries = Scan.scan_dir(dtarget, { hidden = true, depth = 10, add_dirs = false })
    f['netrw#Call']("NetrwLocalRm", dtargetpath:parent().filename)
    if not dtargetpath:exists() then
      for _, entry in ipairs(entries) do
        pcall(c, "bw! " .. rep(entry))
      end
    end
  else
    f['netrw#Call']("NetrwLocalRm", dtarget)
    local path = Path:new(dtarget):joinpath(payload.node)
    if not path:exists() then
      pcall(c, "bw! " .. rep(path.filename))
    end
  end
end

local rename = function(payload)
  if not payload then
    return
  end
  local dtarget = get_dtarget(payload)
  if payload.type == 0 then
    local dtargetpath = Path:new(dtarget)
    local entries = Scan.scan_dir(dtarget, { hidden = true, depth = 10, add_dirs = false })
    f['netrw#Call']("NetrwLocalRename", dtargetpath:parent().filename)
    if not dtargetpath:exists() then
      for _, entry in ipairs(entries) do
        pcall(c, "bw! " .. rep(entry))
      end
    end
  else
    f['netrw#Call']("NetrwLocalRename", dtarget)
    local path = Path:new(dtarget):joinpath(payload.node)
    if not path:exists() then
      pcall(c, "bw! " .. rep(path.filename))
    end
  end
end

netrw.setup {
  use_devicons = true,
  mappings = {
    ['(f1)'] = function(payload) test(payload) end,
    ['(tab)'] = function(payload) preview(payload) end,
    ['(leftmouse)'] = function(payload) toggle_dir(payload) end,
    ['(2-leftmouse)'] = function(payload) preview_file(payload) end,
    ['(s-tab)'] = function(payload) preview_go(payload) end,
    ['(middlemouse)'] = function() updir() end,
    ['q'] = function() updir() end,
    ['o'] = function(payload) open(payload, 'here') end,
    ['do'] = function(payload) open(payload, 'here') end,
    ['dk'] = function(payload) open(payload, 'up') end,
    ['dj'] = function(payload) open(payload, 'down') end,
    ['dh'] = function(payload) open(payload, 'left') end,
    ['dl'] = function(payload) open(payload, 'right') end,
    ['di'] = function(payload) open(payload, 'tab') end,
    ['y'] = function(payload) copy_fname(payload) end,
    ['gy'] = function(payload) copy_fname_full(payload) end,
    ['cd'] = function(payload) chg_dir(payload) end,
    ['X'] = function(payload) explorer(payload) end,
    ['x'] = function(payload) system_start(payload) end,
    ['.'] = function() hide() end,
    ['a'] = function(payload) open(payload, 'here') end,
    ['O'] = function(payload) go_dir(payload) end,
    ['pf'] = function() unfold_all(0) end,
    ['pr'] = function() unfold_all(3) end,
    ['pe'] = function() unfold_all(1) end,
    ['pd'] = function() unfold_all(2) end,
    ['pw'] = function() fold_all() end,
    ['U'] = function() go_parent() end,
    ['K'] = function() go_sibling('up') end,
    ['J'] = function() go_sibling('down') end,
    ['dp'] = function() search_fname('up') end,
    ['dn'] = function() search_fname('down') end,
    ['\''] = function(payload) sel_toggle_cur(payload) end,
    ['"'] = function() sel_toggle_all() end,
    ['|'] = function(payload) sel_all(payload) end,
    ['dE'] = function() empty_sel_list() end,
    ['dD'] = function() delete_sel_list() end,
    ['dM'] = function(payload) move_sel_list(payload) end,
    ['dR'] = function() rename_sel_list() end,
    ['dC'] = function(payload) copy_sel_list(payload) end,
    ['dY'] = function() copy_2_clip() end,
    ['da'] = function(payload) create(payload) end,
    ['dA'] = function(payload) createmulti(payload) end,
    ['ds'] = function(payload) create_dir(payload) end,
    ['dS'] = function(payload) create_dirmulti(payload) end,
    ['D'] = function(payload) delete(payload) end,
    ['R'] = function(payload) rename(payload) end,
  },
}
