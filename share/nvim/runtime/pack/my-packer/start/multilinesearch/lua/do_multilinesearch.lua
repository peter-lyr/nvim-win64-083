local f = vim.fn
local c = vim.cmd

local M = {}

local test2 = function()
  local s = f['getpos']("'<")
  local line1 = s[2]
  local col1 = s[3]
  local e = f['getpos']("'>")
  local line2 = e[2]
  local col2 = e[3]
  local lines = {}
  for lnr=line1, line2 do
    local line = f['getline'](lnr)
    if lnr == line1 and lnr == line2 then
      line = string.sub(line, col1, col2)
    else
      if lnr == line1 then
        line = string.sub(line, col1)
      elseif lnr == line2 then
        line = string.sub(line, 0, col2)
      end
    end
    local cells = {}
    for ch in string.gmatch(line, ".") do
      if ch == "'" then
        table.insert(cells, [["'"]])
      else
        if vim.tbl_contains({'\\', '/'}, ch) then
          ch = '\\' .. ch
        end
        table.insert(cells, string.format([['%s']], ch))
      end
    end
    if #cells > 0 then
      table.insert(lines, table.concat(cells, ' . '))
    else
      table.insert(lines, "''")
    end
  end
  local content = table.concat(lines, " . '\\n' . ")
  c(string.format([[let @/ = "\\V" . %s]], content))
end

local test = function()
  c([[call feedkeys("\<esc>")]])
  local timer = vim.loop.new_timer()
  timer:start(10, 0, function()
    vim.schedule(function()
      test2()
    end)
  end)
end

M.run = function(params)

  if not params or #params == 0 then
    return
  end

  if #params == 1 then
    local param = params[1]
    if param == 'do' then
      test()
    end
  end

end

return M
