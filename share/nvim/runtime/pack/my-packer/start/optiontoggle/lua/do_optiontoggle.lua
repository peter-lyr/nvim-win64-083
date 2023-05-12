local o = vim.opt

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
    end
  end

end

return M
