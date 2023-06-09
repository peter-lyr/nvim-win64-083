local M = {}

local o = vim.opt
local f = vim.fn
local a = vim.api
local c = vim.cmd
local g = vim.g
local s = vim.keymap.set

g.lastbufnr = nil

a.nvim_create_autocmd({ 'VimResized' }, {
  callback = function()
    g.tabline_done = 0
  end,
})

TablineHi = {}

a.nvim_create_autocmd({ 'ColorScheme' }, {
  callback = function()
    for k, v in pairs(TablineHi) do
      local ext = k
      local color = v[2]
      local hl_group = "MyTabline" .. ext
      vim.api.nvim_set_hl(0, hl_group, { fg = color, bold = true })
      vim.api.nvim_set_hl(0, "TablineHi", { fg = '#8ca2c9', bold = true })
      vim.api.nvim_set_hl(0, "TablineDim", { fg = '#626262' })
    end
  end,
})

a.nvim_create_autocmd({ 'BufLeave' }, {
  callback = function()
    if f['filereadable'](a.nvim_buf_get_name(0)) then
      g.lastbufnr = f['bufnr']()
    end
  end,
})

local sta, Path = pcall(require, "plenary.path")
if not sta then
  print(Path)
  return ''
end

local devicons
sta, devicons = pcall(require, "nvim-web-devicons")
if not sta then
  print(devicons)
end

g.tabline_exts = {}
g.tabline_projectroots = {}
Tabline_projectroots = {}

local index_of = function(arr, val)
  if not arr then
    return nil
  end
  for i, v in ipairs(arr) do
    if vim.fn['tolower'](v) == vim.fn['tolower'](val) then
      return i
    end
  end
  return nil
end

local curbufnr
local changebuf

a.nvim_create_autocmd({ 'BufEnter' }, {
  callback = function()
    local path = Path:new(a.nvim_buf_get_name(0))
    if not path:exists() then
      return
    end
    local ext = string.match(path.filename, "%.([^.]+)$")
    if not ext then
      return
    end
    local ic, color = devicons.get_icon_color(path.filename, ext)
    if ic then
      vim.api.nvim_get_hl(0, { name = 'MyTabline' .. ext })
      TablineHi[ext] = { ic, color }
      vim.api.nvim_set_hl(0, "MyTabline" .. ext, { fg = color, bold = true, bg = 'NONE' })
      vim.api.nvim_set_hl(0, "TablineHi", { fg = '#8ca2c9', bold = true })
      vim.api.nvim_set_hl(0, "TablineDim", { fg = '#626262', bg = 'NONE' })
      vim.g.tabline_exts = TablineHi
    end
  end,
})

local update_projectroots = function()
  local tabline_projectroots = {}
  for _, bufnr in ipairs(a.nvim_list_bufs()) do
    if f['buflisted'](bufnr) ~= 0 and a.nvim_buf_is_loaded(bufnr) ~= false and curbufnr ~= bufnr then
      local projectroot = string.gsub(f['projectroot#get'](a.nvim_buf_get_name(bufnr)), '\\', '/')
      table.insert(tabline_projectroots, projectroot)
    end
  end
  g.tabline_projectroots = tabline_projectroots
  local projectroot = string.gsub(f['projectroot#get'](), '\\', '/')
  if #tabline_projectroots > 0 and not index_of(tabline_projectroots, projectroot) then
    return true
  end
  return nil
end

a.nvim_create_autocmd({ 'BufReadPre' }, {
  callback = function()
    local path = Path:new(a.nvim_buf_get_name(0))
    curbufnr = f['bufnr']()
    if not path:exists() then
      return
    end
    local ext = string.match(path.filename, "%.([^.]+)$")
    if not ext then
      return
    end
    if update_projectroots() then
      changebuf = true
    end
  end,
})

a.nvim_create_autocmd({ 'BufReadPost' }, {
  callback = function()
    if changebuf then
      changebuf = nil
      c([[
        try
          b%d
          wincmd v
          wincmd T
          b%d
          let g:tabline_done = 0
        catch
        endtry
      ]], g.lastbufnr, curbufnr)
      -- c('b' .. g.lastbufnr)
      -- c('wincmd v')
      -- c('wincmd T')
      -- c('b' .. curbufnr)
      -- g.tabline_done = 0
    end
  end,
})

local datetime = os.date("%H:%M:%S", g.startuptime)

local function format_time(secs)
  local seconds = secs % 60
  local minutes = math.floor(secs / 60) % 60
  local hours = math.floor(secs / 60 / 60) % 24
  local days = math.floor(secs / 60 / 60 / 24) % 30
  local months = math.floor(secs / 60 / 60 / 24 / 30) % 12
  local years = math.floor(secs / 60 / 60 / 24 / 30 / 12) % 365
  if years > 0 then
    return string.format("%02d/%02d/%02d %02d:%02d:%02d", years, months, days, hours, minutes, seconds)
  elseif months > 0 then
    return string.format("%02d/%02d %02d:%02d:%02d", months, days, hours, minutes, seconds)
  elseif days > 0 then
    return string.format("%02d %02d:%02d:%02d", days, hours, minutes, seconds)
  elseif hours > 0 then
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
  elseif minutes > 0 then
    return string.format("%02d:%02d", minutes, seconds)
  else
    return string.format("%02d", seconds)
  end
end

local timer = vim.loop.new_timer()
timer:start(1000, 1000, function()
  vim.schedule(function()
    local t = format_time(os.difftime(os.time(), g.startuptime))
    t = t .. ' ' .. string.format("%.1f", vim.loop.resident_set_memory()/1024/1024)
    g.process_mem = t
    g.tabline_onesecond = 1
  end)
end)

local tabline_dir = Path:new(g.tabline_lua):parent():parent()['filename']
g.process_exe = Path:new(tabline_dir):joinpath('autoload', 'process.exe')['filename']

local opt = { silent = true }

s({ 'n', 'v' }, '<leader><bs>', ':<c-u>try|exe "b" . g:lastbufnr|catch|endtry<cr>', opt)

M.update_title_string = function()
  local title = vim.loop.cwd()
  if #title > 0 then
    local t1 = title .. ' | ' .. datetime
    if g.colors_name then
      t1 = t1 .. ' ' .. g.colors_name
    end
    o.titlestring = t1
  end
end

return M
