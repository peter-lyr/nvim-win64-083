local g = vim.g
local c = vim.cmd
local a = vim.api
local f = vim.fn

g.set_tabline = a.nvim_create_autocmd({ "TabEnter", "FocusLost" }, {
  callback = function()
    a.nvim_del_autocmd(g.set_tabline)
    c([[set tabline=%!tabline#tabline()]])
  end,
})

a.nvim_create_autocmd({ "WinLeave" }, {
  callback = function()
    local sta, do_tabline = pcall(require, 'do_tabline')
    if not sta then
      print('no do_tabline')
      return
    end
    f['timer_start'](100, do_tabline.update_title_string)
  end,
})
