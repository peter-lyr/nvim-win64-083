local a = vim.api
local f = vim.fn
local g = vim.g

g.ultisnips_lua = f['expand']('<sfile>')

local ultisnips = function()
  if not g.ultisnips_loaded then
    g.ultisnips_loaded = 1
    a.nvim_del_autocmd(g.ultisnips_cursormoved)
    local sta, do_ultisnips = pcall(require, 'do_ultisnips')
    if not sta then
      print(do_ultisnips)
    end
  end
end

if not g.ultisnips_startup then
  g.ultisnips_startup = 1
  g.ultisnips_cursormoved = a.nvim_create_autocmd({ 'InsertEnter', 'CursorMoved', 'FocusLost', 'CursorHold'  }, {
    callback = function()
      ultisnips()
    end,
  })
end
