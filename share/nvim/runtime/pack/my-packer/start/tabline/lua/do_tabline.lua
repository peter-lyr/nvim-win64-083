local M = {}

local o = vim.opt
local f = vim.fn
local a = vim.api
local g = vim.g
local s = vim.keymap.set

g.lastbufnr = nil

TablineHi = {}

a.nvim_create_autocmd({ 'ColorScheme' }, {
  callback = function()
    for k, v in pairs(TablineHi) do
      local ext = k
      local color = v[2]
      local hl_group = "MyTabline" .. ext
      vim.api.nvim_set_hl(0, hl_group, { fg = color })
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
    if not vim.api.nvim_get_hl(0, { name = 'MyTabline' .. ext })['fg'] then
      local ic, color = devicons.get_icon_color(path.filename, ext)
      if ic then
        TablineHi[ext] = { ic, color }
        local hl_group = "MyTabline" .. ext
        vim.api.nvim_set_hl(0, hl_group, { fg = color })
        vim.g.tabline_exts = TablineHi
      end
    end
  end,
})

local time = os.time()
local datetime = os.date("%H:%M:%S", time)

local function format_time(seconds)
  local minutes = math.floor(seconds / 60)
  local hours = math.floor(minutes / 60)
  local days = math.floor(hours / 24)
  local years = math.floor(days / 365)
  local months = math.floor((days % 365) / 30)
  local result = ""
  if years > 0 then
    result = result .. years .. "/"
    days = days % 365
  end
  if months > 0 then
    result = result .. months .. "/"
    days = days % 30
  end
  if days > 0 then
    result = result .. days .. " "
    hours = hours % 24
  end
  if hours > 0 then
    result = result .. hours .. ":"
    minutes = minutes % 60
  end
  if minutes > 0 then
    result = result .. minutes .. ":"
    seconds = seconds % 60
  end
  result = result .. string.format("%02d", seconds)
  return result
end

local timer = vim.loop.new_timer()
timer:start(1000, 1000, function()
  vim.schedule(function()
    local handle = io.popen(string.format("%s \"%s\"", vim.g.process_exe, vim.opt.titlestring:get()))
    if handle then
      local result = handle:read("*a")
      handle:close()
      local a1, b1 = string.match(result, '%S+%s+(%S+)%s+(%S+)%s*$')
      local t = format_time(os.difftime(os.time(), time))
      if a1 and b1 then
        local a2 = string.format("%.1f", tonumber(string.gsub(a1, ',', ''), 10) / 1024)
        t = t .. ' ' .. a2
      end
      g.process_mem = t
      g.tabline_onesecond = 1
    end
  end)
end)

local tabline_dir = Path:new(g.tabline_lua):parent():parent()['filename']
g.process_exe = Path:new(tabline_dir):joinpath('autoload', 'process.exe')['filename']

local opt = { silent = true }

s({ 'n', 'v' }, '<leader><bs>', ':<c-u>try|exe "b" . g:lastbufnr|catch|endtry<cr>', opt)

local get_fname_tail = function(fname)
  fname = string.gsub(fname, "\\", '/')
  local path = Path:new(fname)
  if path:is_file() then
    fname = path:_split()
    return fname[#fname]
  elseif path:is_dir() then
    fname = path:_split()
    if #fname[#fname] > 0 then
      return fname[#fname]
    else
      return fname[#fname - 1]
    end
  end
  return ''
end

M.update_title_string = function()
  local title = get_fname_tail(f['getcwd']())
  if #title > 0 then
    local t1 = title .. ' | ' .. datetime
    if g.colors_name then
      t1 = t1 .. ' ' .. g.colors_name
    end
    o.titlestring = t1
  end
end

return M
