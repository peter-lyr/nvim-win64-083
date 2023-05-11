local c = vim.cmd
local f = vim.fn
local a = vim.api

local sta, colorscheme = pcall(c, 'colorscheme sierra')
if not sta then
  print(colorscheme)
  return
end

ColorSchemes = {}

for _, v in pairs(vim.fn.getcompletion("", "color")) do
  table.insert(ColorSchemes, v)
end

local colors = {}
local do_tabline
local lastcwd = ''

local changecolorscheme = function(force)
  local cwd = string.lower(string.gsub(vim.loop.cwd(), '\\', '/'))
  if force ~= true and (cwd == lastcwd or f['filereadable'](a.nvim_buf_get_name(0)) == 0) then
    return
  end
  lastcwd = cwd
  if not vim.tbl_contains(vim.tbl_keys(colors), cwd) or force == true then
    local color
    for _=1, 5 do
      color = ColorSchemes[math.random(#ColorSchemes)]
      if not string.match(color, 'light') then
        break
      end
    end
    colors[cwd] = color
  end
  if not do_tabline then
    sta, do_tabline = pcall(require, 'do_tabline')
    if not sta then
      print('no do_tabline')
      return
    end
  end
  c(string.format([[call feedkeys(":\<c-u>colorscheme %s\<cr>")]], colors[cwd]))
  vim.fn['timer_start'](100, do_tabline.update_title_string)
end

local changecolorschemedefault = function()
  local cwd = string.lower(string.gsub(vim.loop.cwd(), '\\', '/'))
  if vim.tbl_contains(vim.tbl_keys(colors), cwd) then
    if vim.g.colors_name == 'default' then
      c(string.format([[call feedkeys(":\<c-u>colorscheme %s\<cr>")]], colors[cwd]))
      vim.fn['timer_start'](100, do_tabline.update_title_string)
      return
    end
  end
  c([[call feedkeys(":\<c-u>colorscheme default\<cr>")]])
  vim.fn['timer_start'](100, do_tabline.update_title_string)
end

local timer = vim.loop.new_timer()
timer:start(100, 100, function()
  vim.schedule(function()
    changecolorscheme(false)
  end)
end)

local s = vim.keymap.set
local opt = { silent = true }
s({ 'n', 'v' }, '<leader>bw', function() changecolorscheme(true) end, opt)
s({ 'n', 'v' }, '<leader>bW', function() changecolorschemedefault(true) end, opt)
