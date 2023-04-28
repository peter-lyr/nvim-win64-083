local M = {}

local a = vim.api
local b = vim.b
local c = vim.cmd
local f = vim.fn
local g = vim.g
local m = string.match
local o = vim.opt
local s = vim.keymap.set

local file_exists = function(name)
  local ptr = io.open(name, "r")
  if ptr ~= nil then
    io.close(ptr)
    return true
  else
    return false
  end
end

if not g.bufleave_readablefile_autocmd then
  g.bufleave_readablefile = f['getcwd']()
  g.bufleave_readablefile_autocmd = a.nvim_create_autocmd({ "BufLeave" }, {
    callback = function()
      local fname = a['nvim_buf_get_name'](0)
      if file_exists(fname) then
        g.bufleave_readablefile = fname
      end
    end,
  })
end

function M.is_terminal(bufname, terminal)
  if m(bufname, '^term://') then
    local is_ipython = m(bufname, ':ipython$')
    local is_bash = m(bufname, ':bash$')
    local is_powershell = m(bufname, ':powershell$')
    local is_cmd = m(bufname, ':cmd$')
    if terminal == 'ipython' and is_ipython then
      return true, true
    elseif terminal == 'bash' and is_bash then
      return true, true
    elseif terminal == 'powershell' and is_powershell then
      return true, true
    elseif terminal == 'cmd' and is_cmd then
      return true, true
    else
      return true, false
    end
  end
  return false, false
end

local try_goto_terminal = function()
  for i = 1, f['winnr']('$') do
    local bufnr = f['winbufnr'](i)
    local buftype = f['getbufvar'](bufnr, '&buftype')
    if buftype == 'terminal' then
      f['win_gotoid'](f['win_getid'](i))
      return true
    end
  end
  return false
end

local get_terminal_bufnrs = function(terminal)
  local terminal_bufnrs = {}
  for _, v in pairs(f['getbufinfo']()) do
    local _, certain = M.is_terminal(v['name'], terminal)
    if certain then
      table.insert(terminal_bufnrs, v['bufnr'])
    end
  end
  if #terminal_bufnrs == 0 then
    return nil
  end
  return terminal_bufnrs
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

local Path = require "plenary.path"

function M.get_dname(readablefile)
  if #readablefile == 0 then
    return ''
  end
  local fname = string.gsub(readablefile, "\\", '/')
  local path = Path:new(fname)
  if path:is_file() then
    return path:parent()['filename']
  end
  return ''
end

function M.toggle_terminal(terminal, chdir)
  if g.builtin_terminal_ok == 0 then
    if chdir == '.' then
      chdir = M.get_dname(a['nvim_buf_get_name'](0))
      chdir = string.gsub(chdir, "/", '\\')
    elseif chdir == 'u' then
      chdir = '..'
    elseif chdir == '-' then
      chdir = '-'
    elseif chdir == 'cwd' then
      chdir = f['getcwd']()
    end
    c(string.format('silent !cd %s & start %s', chdir, terminal))
    return
  end
  local fname = a['nvim_buf_get_name'](0)
  local terminal_bufnrs = get_terminal_bufnrs(terminal)
  local one, certain = M.is_terminal(fname, terminal)
  if certain then
    if #chdir > 0 then
      if chdir == '.' then
        chdir = M.get_dname(g.bufleave_readablefile)
      elseif chdir == 'u' then
        chdir = '..'
      elseif chdir == '-' then
        chdir = '-'
      elseif chdir == 'cwd' then
        chdir = f['getcwd']()
      end
      chdir = string.gsub(chdir, "\\", '/')
      a['nvim_chan_send'](b.terminal_job_id, string.format('cd %s', chdir))
      if terminal == 'ipython' then
        f['feedkeys']([[:call feedkeys("i\<cr>\<esc>")]])
        local t0 = os.clock()
        while os.clock() - t0 <= 0.02 do
        end
        c [[call feedkeys("\<cr>")]]
      else
        c [[call feedkeys("i\<cr>\<esc>")]]
      end
      return
    else
      if #terminal_bufnrs == 1 then
        if is_hide_en() then
          c 'hide'
        end
        return
      end
    end
    local bnr_idx = index_of(terminal_bufnrs, f['bufnr']())
    bnr_idx = bnr_idx + 1
    if bnr_idx > #terminal_bufnrs then
      if is_hide_en() then
        c 'hide'
      end
      return
    else
      c(string.format("b%d", terminal_bufnrs[bnr_idx]))
    end
  else
    if terminal_bufnrs then
      if not try_goto_terminal() then
        if #fname > 0 or o.modified:get() == true then
          c 'split'
        end
      end
      c(string.format("b%d", terminal_bufnrs[1]))
    else
      if not one then
        c 'split'
      end
      c(string.format('te %s', terminal))
    end
    if #chdir > 0 then
      M.toggle_terminal(terminal, chdir)
    end
  end
end

local get_paragraph = function(sep)
  local paragraph = {}
  local linenr = f['line']('.')
  local lines = 0
  for i = linenr, 1, -1 do
    local line = f['getline'](i)
    if #line > 0 then
      lines = lines + 1
      table.insert(paragraph, 1, line)
    else
      break
    end
  end
  for i = linenr + 1, f['line']('$') do
    local line = f['getline'](i)
    if #line > 0 then
      table.insert(paragraph, line)
      lines = lines + 1
    else
      break
    end
  end
  return table.concat(paragraph, sep)
end

function M.send_cmd(terminal, to_send, show) -- show时，send后不hide
  if g.builtin_terminal_ok == 0 then
    c(string.format('silent !start %s', terminal))
    return
  end
  local cmd_to_send = ''
  if to_send == 'curline' then
    cmd_to_send = f['getline']('.')
  elseif to_send == 'paragraph' then
    if terminal == 'to_send' then
      cmd_to_send = get_paragraph(' && ')
    elseif terminal == 'powershell' then
      cmd_to_send = get_paragraph('; ')
    else
      cmd_to_send = get_paragraph('\n')
    end
  elseif to_send == 'clipboard' then
    local clipboard = f['getreg']('+')
    clipboard = clipboard:gsub("^%s*(.-)%s*$", "%1") -- trim_string
    if terminal == 'to_send' then
      cmd_to_send = string.gsub(clipboard, '\n', ' && ')
    elseif terminal == 'powershell' then
      cmd_to_send = string.gsub(clipboard, '\n', '; ')
    elseif terminal == 'ipython' then
      cmd_to_send = '%paste'
    else
      cmd_to_send = clipboard
    end
    print('cmd_to_send', cmd_to_send)
  else
    cmd_to_send = to_send
  end
  local fname = a['nvim_buf_get_name'](0)
  local terminal_bufnrs = get_terminal_bufnrs(terminal)
  local one, certain = M.is_terminal(fname, terminal)
  if certain then
    a['nvim_chan_send'](b.terminal_job_id, cmd_to_send)
    if terminal == 'ipython' then
      f['feedkeys']([[:call feedkeys("i\<cr>\<esc>")]])
      local t0 = os.clock()
      while os.clock() - t0 <= 0.02 do
      end
      c [[call feedkeys("\<cr>")]]
    else
      c [[call feedkeys("i\<cr>\<esc>")]]
    end
    if show ~= 'show' then
      if is_hide_en() then
        vim.loop.new_timer():start(100, 0,
          function()
            vim.schedule(function()
              c 'hide'
            end)
          end)
      end
    end
  else
    if terminal_bufnrs then
      if not try_goto_terminal() then
        if #fname > 0 or o.modified:get() == true then
          c 'split'
        end
      end
      c(string.format("b%d", terminal_bufnrs[1]))
    else
      if not one then
        c 'split'
      end
      c(string.format('te %s', terminal))
    end
    if #cmd_to_send > 0 then
      M.send_cmd(terminal, cmd_to_send, show)
    end
  end
end

function M.run(params)
  if not params or #params == 0 then
    return
  end
  local terminal = params[1]
  if #params == 1 then
    M.toggle_terminal(terminal, '')
  elseif #params == 2 then
    local chdir = params[2]
    M.toggle_terminal(terminal, chdir)
  elseif #params == 4 then
    local send = params[2]
    if send == 'send' then
      local to_send = params[3]
      local show = params[4]
      Do_terminal.send_cmd(terminal, to_send, show)
    end
  end
end

local opt = { silent = true }

s({ 'n', 'v' }, '\\<bs>q', ':TerminaL cmd cwd<cr>', opt)
s({ 'n', 'v' }, '\\<bs>w', ':TerminaL ipython cwd<cr>', opt)
s({ 'n', 'v' }, '\\<bs>e', ':TerminaL bash cwd<cr>', opt)
s({ 'n', 'v' }, '\\<bs>r', ':TerminaL powershell cwd<cr>', opt)

s({ 'n', 'v' }, '\\\\q', ':TerminaL cmd .<cr>', opt)
s({ 'n', 'v' }, '\\\\w', ':TerminaL ipython .<cr>', opt)
s({ 'n', 'v' }, '\\\\e', ':TerminaL bash .<cr>', opt)
s({ 'n', 'v' }, '\\\\r', ':TerminaL powershell .<cr>', opt)

s({ 'n', 'v' }, '\\[q', ':TerminaL cmd u<cr>', opt)
s({ 'n', 'v' }, '\\[w', ':TerminaL ipython u<cr>', opt)
s({ 'n', 'v' }, '\\[e', ':TerminaL bash u<cr>', opt)
s({ 'n', 'v' }, '\\[r', ':TerminaL powershell u<cr>', opt)

s({ 'n', 'v' }, '\\]q', ':TerminaL cmd -<cr>', opt)
s({ 'n', 'v' }, '\\]w', ':TerminaL ipython -<cr>', opt)
s({ 'n', 'v' }, '\\]e', ':TerminaL bash -<cr>', opt)
s({ 'n', 'v' }, '\\]r', ':TerminaL powershell -<cr>', opt)


s({ 'n', 'v' }, '\\<cr>q', ':TerminaL cmd send curline show<cr>', opt)
s({ 'n', 'v' }, '\\<cr>w', ':TerminaL ipython send curline show<cr>', opt)
s({ 'n', 'v' }, '\\<cr>e', ':TerminaL bash send curline show<cr>', opt)
s({ 'n', 'v' }, '\\<cr>r', ':TerminaL powershell send curline show<cr>', opt)

s({ 'n', 'v' }, '\\<cr><cr>q', ':TerminaL cmd send paragraph show<cr>', opt)
s({ 'n', 'v' }, '\\<cr><cr>w', ':TerminaL ipython send paragraph show<cr>', opt)
s({ 'n', 'v' }, '\\<cr><cr>e', ':TerminaL bash send paragraph show<cr>', opt)
s({ 'n', 'v' }, '\\<cr><cr>r', ':TerminaL powershell send paragraph show<cr>', opt)

s({ 'n', 'v' }, '\\<cr><cr><cr>q', ':TerminaL cmd send clipboard show<cr>', opt)
s({ 'n', 'v' }, '\\<cr><cr><cr>w', ':TerminaL ipython send clipboard show<cr>', opt)
s({ 'n', 'v' }, '\\<cr><cr><cr>e', ':TerminaL bash send clipboard show<cr>', opt)
s({ 'n', 'v' }, '\\<cr><cr><cr>r', ':TerminaL powershell send clipboard show<cr>', opt)

return M
