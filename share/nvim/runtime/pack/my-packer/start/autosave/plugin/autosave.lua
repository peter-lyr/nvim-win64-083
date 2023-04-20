local a = vim.api
local g = vim.g

local autosave = function()
  if not g.autosave_loaded then
    g.autosave_loaded = 1
    a.nvim_del_autocmd(g.autosave_cursormoved)
    local sta, do_autosave = pcall(require, 'do_autosave')
    if not sta then
      print(do_autosave)
    end
  end
end

if not g.autosave_startup then
  g.autosave_startup = 1
  g.autosave_cursormoved = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
    callback = function()
      autosave()
    end,
  })
end
