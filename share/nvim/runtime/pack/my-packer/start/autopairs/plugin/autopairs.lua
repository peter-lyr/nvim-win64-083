local a = vim.api
local g = vim.g

local autopairs = function()
  if not g.autopairs_loaded then
    g.autopairs_loaded = 1
    if g.autopairs_cursormoved then
      a.nvim_del_autocmd(g.autopairs_cursormoved)
    end
    local sta, do_autopairs = pcall(require, 'do_autopairs')
    if not sta then
      print(do_autopairs)
    end
  end
end

if not g.autopairs_startup then
  g.autopairs_startup = 1
  g.autopairs_cursormoved = a.nvim_create_autocmd({"InsertEnter", "FocusLost"}, {
    callback = function()
      autopairs()
    end,
  })
end
