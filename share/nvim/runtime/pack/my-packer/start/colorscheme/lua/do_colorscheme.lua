local c = vim.cmd
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

local changecolorscheme = function()
  c(string.format([[call feedkeys("colorscheme %s")]], ColorSchemes[math.random(#ColorSchemes)]))
end

a.nvim_create_autocmd({ 'TabEnter', }, {
  callback = function()
    changecolorscheme()
  end,
})
