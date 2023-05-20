local o = vim.opt
local c = vim.cmd
local f = vim.fn

local M = {}

M.windodiffoff = function()
  local winnr = f['bufwinnr'](f['bufnr']())
  c([[call feedkeys(":\<c-u>windo diffoff\<cr>")]])
  local timer = vim.loop.new_timer()
  local cnt = 0
  local b1 = nil
  timer:start(20, 20, function()
    vim.schedule(function()
      local b2 = f['bufnr']()
      if b1 == b2 then
        timer:stop()
        c(string.format([[%dwincmd w]], winnr))
      end
      b1 = b2
      cnt = cnt + 1
      if cnt > 100 then
        timer:stop()
        c(string.format([[%dwincmd w]], winnr))
      end
    end)
  end)
end

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
        c([[call feedkeys(":\<c-u>diffoff\<cr>")]])
      else
        c([[call feedkeys(":\<c-u>diffthis\<cr>")]])
      end
    elseif option == 'diffthis!' then
      M.windodiffoff()
    end
  end

end

return M
