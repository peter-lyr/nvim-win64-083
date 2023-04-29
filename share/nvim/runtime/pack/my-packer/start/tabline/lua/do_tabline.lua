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

M.update_title_string = function()
  local title = get_fname_tail(f['getcwd']())
  if #title > 0 then
    o.titlestring = title
  end
end

return M
