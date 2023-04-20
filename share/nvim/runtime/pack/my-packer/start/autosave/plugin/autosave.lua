local a = vim.api

local autosave_cursormoved

local autosave = function()
  a.nvim_del_autocmd(autosave_cursormoved)
  local sta, do_autosave = pcall(require, 'do_autosave')
  if not sta then
    print(do_autosave)
  end
end

autosave_cursormoved = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    autosave()
  end,
})
