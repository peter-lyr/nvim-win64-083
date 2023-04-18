local a = vim.api
local g = vim.g

local surround = function()
  if not g.surround_loaded then
    g.surround_loaded = 1
    if g.surround_cursormoved then
      a.nvim_del_autocmd(g.surround_cursormoved)
    end
    local sta, do_surround = pcall(require, 'do_surround')
    if not sta then
      print(do_surround)
    end
  end
end

if not g.surround_startup then
  g.surround_startup = 1
  g.surround_cursormoved = a.nvim_create_autocmd({"InsertEnter"}, {
    callback = function()
      a.nvim_del_autocmd(g.surround_cursormoved)
      surround()
    end,
  })
end
