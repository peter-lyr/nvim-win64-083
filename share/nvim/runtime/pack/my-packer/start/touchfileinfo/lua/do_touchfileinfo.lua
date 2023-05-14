local a = vim.api
local f = vim.fn

local M = {}

M.run = function(params)

  if not params or #params == 0 then
    return
  end

  if #params == 1 then
    local param = params[1]
    if param == 'create' then
      local fname = f['tolower'](string.format(a.nvim_buf_get_name(0), '\\', '/'))
      local projectroot = f['tolower'](string.format(f['projectroot#get'](fname), '\\', '/'))
      if projectroot[#projectroot] ~= '/' then
        projectroot = projectroot .. '/'
      end
      fname = string.gsub(fname, projectroot, '')
      f['append'](0, {
        '=============================================================================',
        'Filename: ' .. fname,
        'Author: peter-lyr',
        'License: MIT License',
        string.format('Create Datetime: %s.', f['strftime']('%c')),
        '=============================================================================',
      })
    end
  end

end

return M
