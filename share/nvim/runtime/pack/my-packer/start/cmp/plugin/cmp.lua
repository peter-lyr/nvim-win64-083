local a = vim.api
local g = vim.g

local cmp = function()
  if not g.cmp_loaded then
    g.cmp_loaded = 1
    a.nvim_del_autocmd(g.cmp_cursormoved)
    local sta, do_cmp = pcall(require, 'do_cmp')
    if not sta then
      print(do_cmp)
    end
  end
end

if not g.cmp_startup then
  g.cmp_startup = 1
  g.cmp_cursormoved = a.nvim_create_autocmd({ 'InsertEnter', 'CursorMoved', 'CmdlineEnter', 'FocusLost' }, {
    callback = function()
      cmp()
    end,
  })
end
