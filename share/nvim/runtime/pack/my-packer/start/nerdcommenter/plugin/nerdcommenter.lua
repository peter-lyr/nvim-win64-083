local a = vim.api

local nerdcommenter_cursormoved = nil
local nerdcommenter_loaded = nil

local nerdcommenter = function()
  if not nerdcommenter_loaded then
    nerdcommenter_loaded = 1
    a.nvim_del_autocmd(nerdcommenter_cursormoved)
    local sta, do_nerdcommenter = pcall(require, 'do_nerdcommenter')
    if not sta then
      print(do_nerdcommenter)
    end
  end
end

nerdcommenter_cursormoved = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    nerdcommenter()
  end,
})
