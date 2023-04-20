local a = vim.api
local c = vim.cmd
local g = vim.g

if not g.colorscheme_startup then
  g.colorscheme_startup = 1
  g.colorscheme_cursormoved = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
    callback = function()
      a.nvim_del_autocmd(g.colorscheme_cursormoved)
      local sta, colorscheme = pcall(c, 'colorscheme sierra')
      if not sta then
        print(colorscheme)
        return
      end
    end,
  })
end
