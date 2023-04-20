local a = vim.api

local cmp_cursormoved = nil
local cmp_loaded = nil

local cmp = function()
  if not cmp_loaded then
    cmp_loaded = 1
    a.nvim_del_autocmd(cmp_cursormoved)
    local sta, do_cmp = pcall(require, 'do_cmp')
    if not sta then
      print(do_cmp)
    end
  end
end

cmp_cursormoved = a.nvim_create_autocmd({ 'InsertEnter', 'CursorMoved', 'CmdlineEnter', 'FocusLost' }, {
  callback = function()
    cmp()
  end,
})
