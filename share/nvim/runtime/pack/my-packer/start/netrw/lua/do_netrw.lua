local g = vim.g
local a = vim.api
local o = vim.opt

local sta
local config_netrw
local toggle_netrw

g.netrw_mousemaps = 0
g.netrw_sizestyle = "H"
g.netrw_preview = 1
g.netrw_alto = 0
g.netrw_winsize = 120
g.netrw_list_hide = ""
g.netrw_dirhistmax = 0
g.netrw_hide = 0
g.netrw_dynamic_maxfilenamelen = 1
g.netrw_timefmt = "%Y-%m-%d %H:%M:%S %a"
g.netrw_liststyle = 1
g.netrw_sort_by = 'exten'

sta, config_netrw = pcall(require, 'config_netrw')
if not sta then
  print(config_netrw)
  return
end

sta, toggle_netrw = pcall(require, 'toggle_netrw')
if not sta then
  print(toggle_netrw)
  return
end

local bufenter_netrw = function()
  if o.ft:get() == 'netrw' then
    if g.netrw_leader_flag and g.netrw_leader_flag == 0 then
      if o.winfixwidth:get() then
        if not toggle_netrw then
          return
        end
        toggle_netrw.netrw_fix_set_width()
      end
    end
  end
end

a.nvim_create_autocmd({ "BufEnter" }, {
  callback = bufenter_netrw,
})

local M = {}

M.run = function(params)
  if not params or #params == 0 then
    return
  end
  local cmd = params[1]
  g.netrw_leader_flag = 1
  if cmd == 'fix_unfix' then
    toggle_netrw.fix_unfix('cwd')
  elseif cmd == 'toggle_fix' then
    toggle_netrw.toggle('fix')
  elseif cmd == 'toggle_search_fname' then
    toggle_netrw.toggle('cur_fname')
  elseif cmd == 'toggle_search_cwd' then
    toggle_netrw.toggle('cwd')
  elseif cmd == 'toggle_search_sel' then
    toggle_netrw.toggle('sel')
  end
  g.netrw_leader_flag = 0
end

return M
