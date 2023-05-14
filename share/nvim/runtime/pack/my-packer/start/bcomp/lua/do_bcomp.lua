local a = vim.api
local f = vim.fn
local c = vim.cmd

local M = {}

local Path = require("plenary.path")

local file1 = ''
local file2 = ''

M.run = function(params)

  if not params or #params == 0 then
    return
  end

  if #params == 1 then
    local param = params[1]
    local fpath = Path:new(a.nvim_buf_get_name(0))
    if not fpath:exists() then
      local tempfname1 = string.gsub(fpath.filename, '\\', '/')
      local tempfname2 = string.match(tempfname1, '.*/([^/]+)')
      local temppath = Path:new(f['expand']('$TEMP'))
      fpath = temppath:joinpath(tempfname2)
      fpath:write(table.concat(f['getline'](1, f['line']('$')), '\n'), 'w')
    end
    if param == '1' then
      file1 = fpath.filename
    elseif param == '2' then
      if #file1 == 0 then
        file1 = fpath.filename
        c('echo "bcomp file1: ' .. file1 .. '"')
      else
        file2 = fpath.filename
        c('echo "bcomp file2: ' .. file2 .. '"')
        c(string.format([[silent !start /b /min cmd /c "bcomp "%s" "%s""]], file1, file2))
      end
    end
    if param == '3' then
      if #file1 > 0 and #file2 > 0 then
        c(string.format([[silent !start /b /min cmd /c "bcomp "%s" "%s""]], file1, file2))
      end
    end
  end


end

return M
