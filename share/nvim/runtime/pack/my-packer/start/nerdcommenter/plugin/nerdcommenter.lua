local a = vim.api
local g = vim.g

local nerdcommenter = function()
  if not g.nerdcommenter_loaded then
    g.nerdcommenter_loaded = 1
    a.nvim_del_autocmd(g.nerdcommenter_cursormoved)
    local sta, do_nerdcommenter = pcall(require, 'do_nerdcommenter')
    if not sta then
      print(do_nerdcommenter)
    end
  end
end

if not g.nerdcommenter_startup then
  g.nerdcommenter_startup = 1
  g.nerdcommenter_cursormoved = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
    callback = function()
      nerdcommenter()
    end,
  })
end
