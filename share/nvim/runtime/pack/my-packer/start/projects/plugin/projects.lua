local a = vim.api
local g = vim.g

local sta

local projects = function()
  if not g.projects_loaded then
    g.projects_loaded = 1
    a.nvim_del_autocmd(g.projects_cursormoved)
    sta, g.do_projects = pcall(require, 'do_projects')
    if not sta then
      print(g.do_projects)
      return
    end
  end
end

if not g.projects_startup then
  g.projects_startup = 1
  g.projects_cursormoved = a.nvim_create_autocmd({ "CursorMoved", "FocusLost" }, {
    callback = function()
      a.nvim_del_autocmd(g.projects_cursormoved)
      projects()
    end,
  })
end
