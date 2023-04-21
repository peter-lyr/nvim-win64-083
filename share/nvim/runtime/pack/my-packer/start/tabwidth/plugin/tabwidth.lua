local o = vim.opt
local a = vim.api

local isInTable = function(value, tbl)
  for _, v in ipairs(tbl) do
    if v == value then
      return true
    end
  end
  return false
end

local lang = {
  'c',
  'cpp',
  'python',
}

local tab_width = function()
  if isInTable(o.filetype:get(), lang) then
    o.tabstop = 4
    o.softtabstop = 4
    o.shiftwidth = 4
  else
    o.tabstop = 2
    o.softtabstop = 2
    o.shiftwidth = 2
  end
end

a.nvim_create_autocmd({ "BufEnter" }, {
  callback = tab_width,
})
