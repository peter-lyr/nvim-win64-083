local M = {}

local o = vim.opt
local f = vim.fn
local a = vim.api
local g = vim.g
local s = vim.keymap.set

g.lastbufnr = nil

a.nvim_create_autocmd({ 'BufLeave' }, {
  callback = function()
    if f['filereadable'](a.nvim_buf_get_name(0)) then
      g.lastbufnr = f['bufnr']()
    end
  end,
})

local timer = vim.loop.new_timer()
timer:start(1000, 1000, function()
  vim.schedule(function()
    local handle = io.popen(string.format("%s \"%s\"", vim.g.process_exe, vim.opt.titlestring:get()))
    if handle then
      local result = handle:read("*a")
      handle:close()
      local a1, b1 = string.match(result, '%S+%s+(%S+)%s+(%S+)%s*$')
      g.process_mem = a1 .. b1
    end
  end)
end)

local tabline_dir = Path:new(g.tabline_lua):parent():parent()['filename']
g.process_exe = Path:new(tabline_dir):joinpath('autoload', 'process.exe')['filename']

local opt = { silent = true }

s({ 'n', 'v' }, '<leader><bs>', ':<c-u>try|exe "b" . g:lastbufnr|catch|endtry<cr>', opt)

local get_fname_tail = function(fname)
  fname = string.gsub(fname, "\\", '/')
  local sta, path = pcall(require, "plenary.path")
  if not sta then
    print('tabline_show no plenary.path')
    return ''
  end
  path = path:new(fname)
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

local datetime = os.date("%Y/%m/%d %H:%M:%S")

M.update_title_string = function()
  local title = get_fname_tail(f['getcwd']())
  if #title > 0 then
    o.titlestring = title .. ' - ' .. datetime
  end
end

return M
