local a = vim.api

local do_projects = nil
local projects_loaded = nil
local projects_cursormoved = nil

local sta

local projects = function()
  if not projects_loaded then
    projects_loaded = 1
    a.nvim_del_autocmd(projects_cursormoved)
    sta, do_projects = pcall(require, 'do_projects')
    if not sta then
      print(do_projects)
      return
    end
  end
end

projects_cursormoved = a.nvim_create_autocmd({ 'InsertEnter', 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    projects()
  end,
})
