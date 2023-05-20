local a = vim.api

local sta

local do_statuscol
local statuscol_autocmd

local statuscol_loaded = nil
-- package.loaded['do_statuscol'] = nil

local init = function()
  if not statuscol_loaded then
    statuscol_loaded = true
    sta, do_statuscol = pcall(require, 'do_statuscol')
    if not sta then
      print(do_statuscol)
      return nil
    end
  end
  if statuscol_autocmd then
    a.nvim_del_autocmd(statuscol_autocmd)
    statuscol_autocmd = nil
  end
  return true
end

local statuscol = function()
  if not init() then
    return
  end
end


statuscol_autocmd = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    statuscol()
  end,
})
