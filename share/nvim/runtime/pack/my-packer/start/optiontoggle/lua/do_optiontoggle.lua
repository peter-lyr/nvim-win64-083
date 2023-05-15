local o = vim.opt
local c = vim.cmd

local M = {}

M.run = function(params)

  if not params or #params == 0 then
    return
  end

  if #params == 1 then
    local option = params[1]
    if option == 'wrap' then
      if o.wrap:get() == true then
        o.wrap = false
      else
        o.wrap = true
      end
    elseif option == 'diffthis' then
      if o.diff:get() == true then
        o.diff = false
        c('ec "diffoff"')
      else
        o.diff = true
        c('ec "diffthis"')
      end
    end
  end

end

return M
