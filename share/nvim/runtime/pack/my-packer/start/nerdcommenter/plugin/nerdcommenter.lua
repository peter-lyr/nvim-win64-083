local a = vim.api
local g = vim.g

local nerdcommenter = function()
  if not g.nerdcommenter_loaded then
    g.nerdcommenter_loaded = 1
    if g.nerdcommenter_cursormoved then
      a.nvim_del_autocmd(g.nerdcommenter_cursormoved)
    end
    local sta, do_nerdcommenter = pcall(require, 'do_nerdcommenter')
    if not sta then
      print(do_nerdcommenter)
    end
  end
end

if not g.nerdcommenter_startup then
  g.nerdcommenter_startup = 1
  g.nerdcommenter_cursormoved = a.nvim_create_autocmd({ "CursorMoved", "FocusLost" }, {
    callback = function()
      a.nvim_del_autocmd(g.nerdcommenter_cursormoved)
      nerdcommenter()
    end,
  })
end
