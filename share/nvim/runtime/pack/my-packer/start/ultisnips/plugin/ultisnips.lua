local a = vim.api
local f = vim.fn
local g = vim.g

local ultisnips_cursormoved = nil
local ultisnips_loaded = nil

g.ultisnips_lua = f['expand']('<sfile>')

local ultisnips = function()
  if not ultisnips_loaded then
    ultisnips_loaded = 1
    a.nvim_del_autocmd(ultisnips_cursormoved)
    local sta, do_ultisnips = pcall(require, 'do_ultisnips')
    if not sta then
      print(do_ultisnips)
    end
  end
end

ultisnips_cursormoved = a.nvim_create_autocmd({ 'InsertEnter', 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    ultisnips()
  end,
})
