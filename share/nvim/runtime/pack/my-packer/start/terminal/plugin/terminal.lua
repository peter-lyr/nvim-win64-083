local s = vim.keymap.set
local a = vim.api
local c = vim.cmd
local f = vim.fn
local g = vim.g


g.builtin_terminal_ok = 1


local terminal_exe = function(cmd, chdir)
  if not g.loaded_do_terminal then
    g.loaded_do_terminal = 1
    sta, do_terminal = pcall(require, 'do_terminal')
    if not sta then
      print('no do_terminal')
      return
    end
    sta, split_string = pcall(require, 'split_string')
    if not sta then
      print('no split_string')
      return
    end
  end
  if split_string then
    local mytable = split_string.split_string(chdir, " ")
    if mytable and #mytable == 3 and mytable[1] == 'send' then
      local one, certain = do_terminal.is_terminal(a['nvim_buf_get_name'](0), cmd)
      if not one or mytable[2] == 'clipboard' then
        do_terminal.send_cmd(cmd, mytable[2], mytable[3])
      end
      return
    end
  end
  if not do_terminal then
    return
  end
  do_terminal.toggle_terminal(cmd, chdir)
end


s('n', '\\q', function() terminal_exe('cmd', '') end, { silent = true})
s('n', '\\w', function() terminal_exe('ipython', '') end, { silent = true})
s('n', '\\e', function() terminal_exe('bash', '') end, { silent = true})
s('n', '\\r', function() terminal_exe('powershell', '') end, { silent = true})


s('n', '\\<bs>q', function() terminal_exe('cmd', f['getcwd']()) end, { silent = true})
s('n', '\\<bs>w', function() terminal_exe('ipython', f['getcwd']()) end, { silent = true})
s('n', '\\<bs>e', function() terminal_exe('bash', f['getcwd']()) end, { silent = true})
s('n', '\\<bs>r', function() terminal_exe('powershell', f['getcwd']()) end, { silent = true})

s('n', '\\\\q', function() terminal_exe('cmd', '.') end, { silent = true})
s('n', '\\\\w', function() terminal_exe('ipython', '.') end, { silent = true})
s('n', '\\\\e', function() terminal_exe('bash', '.') end, { silent = true})
s('n', '\\\\r', function() terminal_exe('powershell', '.') end, { silent = true})

s('n', '\\[q', function() terminal_exe('cmd', 'u') end, { silent = true})
s('n', '\\[w', function() terminal_exe('ipython', 'u') end, { silent = true})
s('n', '\\[e', function() terminal_exe('bash', 'u') end, { silent = true})
s('n', '\\[r', function() terminal_exe('powershell', 'u') end, { silent = true})

s('n', '\\]q', function() terminal_exe('cmd', '-') end, { silent = true})
s('n', '\\]w', function() terminal_exe('ipython', '-') end, { silent = true})
s('n', '\\]e', function() terminal_exe('bash', '-') end, { silent = true})
s('n', '\\]r', function() terminal_exe('powershell', '-') end, { silent = true})


s('n', '\\<cr>q', function() terminal_exe('cmd', 'send <curline> 1') end, { silent = true})
s('n', '\\<cr>w', function() terminal_exe('ipython', 'send <curline> 1') end, { silent = true})
s('n', '\\<cr>e', function() terminal_exe('bash', 'send <curline> 1') end, { silent = true})
s('n', '\\<cr>r', function() terminal_exe('powershell', 'send <curline> 1') end, { silent = true})

s('n', '\\<cr><cr>q', function() terminal_exe('cmd', 'send <paragraph> 1') end, { silent = true})
s('n', '\\<cr><cr>w', function() terminal_exe('ipython', 'send <paragraph> 1') end, { silent = true})
s('n', '\\<cr><cr>e', function() terminal_exe('bash', 'send <paragraph> 1') end, { silent = true})
s('n', '\\<cr><cr>r', function() terminal_exe('powershell', 'send <paragraph> 1') end, { silent = true})

s('n', '\\<cr><cr><cr>q', function() terminal_exe('cmd', 'send <clipboard> 1') end, { silent = true})
s('n', '\\<cr><cr><cr>w', function() terminal_exe('ipython', 'send <clipboard> 1') end, { silent = true})
s('n', '\\<cr><cr><cr>e', function() terminal_exe('bash', 'send <clipboard> 1') end, { silent = true})
s('n', '\\<cr><cr><cr>r', function() terminal_exe('powershell', 'send <clipboard> 1') end, { silent = true})


function file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end


if not g.bufleave_readablefile_autocmd then
  g.bufleave_readablefile = f['getcwd']()
  g.bufleave_readablefile_autocmd = a.nvim_create_autocmd({"BufLeave"}, {
    callback = function()
      local fname = a['nvim_buf_get_name'](0)
      if file_exists(fname) then
        g.bufleave_readablefile = fname
      end
    end,
  })
end
