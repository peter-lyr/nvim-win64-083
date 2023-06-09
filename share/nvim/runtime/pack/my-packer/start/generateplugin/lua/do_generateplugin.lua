local f = vim.fn
local g = vim.g

local M = {}

local Path = require("plenary.path")

local generateplugin_path = Path:new(g.generateplugin_lua):parent():parent()
local start_path = generateplugin_path:parent()
local do_generateplugin_lua_path = generateplugin_path:joinpath('lua', 'do_generateplugin.lua')
local do_generateplugin_plugin_path = generateplugin_path:joinpath('plugin', 'generateplugin.lua')

M.run = function(params)

  -- if not params or #params == 0 then
  --   return
  -- end

  -- 以下自定义，可删除
  if not params or #params > 0 and #params[1] == 'do' then
    return
  end
  local read = function(path, dirname)
    local content = {}
    local lines = path:readlines()
    for _, v in ipairs(lines) do
      local newline, _ = string.gsub(v, 'generateplugin', dirname)
      local s1, _ = string.sub(dirname, 1, 1)
      local s2, _ = string.sub(dirname, 2, #dirname - 1)
      local s3, _ = string.sub(dirname, #dirname, #dirname)
      newline, _ = string.gsub(newline, 'GeneratePlugiN', f['toupper'](s1) .. s2 .. f['toupper'](s3))
      table.insert(content, newline)
    end
    return content
  end
  local dirname = f['input']('generate new plugin, input name: ', 'runbat')
  if not dirname or dirname == '' then
    print('\ncanceled!')
    return
  end
  if dirname == 'do' then
    print('\nnot allowed: "do"!')
    return
  end
  local res = string.match(dirname, '^.*([^0-9a-zA-Z_]+).*$')
  if res then
    print('\n' .. dirname .. ' match "' .. res .. '", not allowed!')
    return
  end
  local do_generateplugin_plugin_content = table.concat(read(do_generateplugin_plugin_path, dirname), '\n')
  local do_generateplugin_lua_content = table.concat(read(do_generateplugin_lua_path, dirname), '\n')
  local dirpath = start_path:joinpath(dirname)
  if not dirpath:exists() then
    dirpath:mkdir()
  end
  local plugindirpath = dirpath:joinpath('plugin')
  if not plugindirpath:exists() then
    plugindirpath:mkdir()
  end
  local luadirpath = dirpath:joinpath('lua')
  if not luadirpath:exists() then
    luadirpath:mkdir()
  end
  local pluginnamepath = plugindirpath:joinpath(dirname .. '.lua')
  if not pluginnamepath:exists() then
    pluginnamepath:write(do_generateplugin_plugin_content, 'w')
  end
  local luanamepath = luadirpath:joinpath('do_' .. dirname .. '.lua')
  if not luanamepath:exists() then
    luanamepath:write(do_generateplugin_lua_content, 'w')
  end
  -- 以上自定义，可删除

end

return M
