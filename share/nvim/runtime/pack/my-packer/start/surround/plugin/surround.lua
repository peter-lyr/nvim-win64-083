local a = vim.api

local surround_cursormoved = nil
local surround_loaded = nil

local surround = function()
  if not surround_loaded then
    surround_loaded = 1
    a.nvim_del_autocmd(surround_cursormoved)
    local sta, do_surround = pcall(require, 'do_surround')
    if not sta then
      print(do_surround)
    end
  end
end

surround_cursormoved = a.nvim_create_autocmd({ 'InsertEnter', 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    surround()
  end,
})
