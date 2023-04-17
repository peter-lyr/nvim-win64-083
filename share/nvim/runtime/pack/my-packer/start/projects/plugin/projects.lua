local a = vim.api
local g = vim.g

local projects = function()
  if not g.projects_loaded then
    g.projects_loaded = 1
    a.nvim_del_autocmd(g.projects_cursormoved)
    local sta, do_projects = pcall(require, 'do_projects')
    if not sta then
      print(do_projects)
      return
    end
  end
end

if not g.projects_startup then
  g.projects_startup = 1
  g.projects_cursormoved = a.nvim_create_autocmd({ "CursorMoved" }, {
    callback = function()
      a.nvim_del_autocmd(g.projects_cursormoved)
      projects()
    end,
  })
end
