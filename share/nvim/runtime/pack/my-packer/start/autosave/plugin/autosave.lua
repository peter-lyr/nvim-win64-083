local a = vim.api
local g = vim.g

local autosave = function()
  if not g.autosave_loaded then
    g.autosave_loaded = 1
    if g.autosave_cursormoved then
      a.nvim_del_autocmd(g.autosave_cursormoved)
    end
    local sta, do_autosave = pcall(require, 'do_autosave')
    if not sta then
      print(do_autosave)
    end
  end
end

if not g.autosave_startup then
  g.autosave_startup = 1
  g.autosave_cursormoved = a.nvim_create_autocmd({"CursorMoved"}, {
    callback = function()
      a.nvim_del_autocmd(g.autosave_cursormoved)
      autosave()
    end,
  })
end
