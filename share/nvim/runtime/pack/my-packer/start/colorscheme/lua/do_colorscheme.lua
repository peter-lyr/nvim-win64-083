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
  local color
  local cnt = 0
  while 1 do
    color = ColorSchemes[math.random(#ColorSchemes)]
    if not string.match(color, 'light') then
      break
    end
    cnt = cnt + 1
    if cnt > 5 then
      break
    end
  end
  c(string.format([[call feedkeys(":\<c-u>colorscheme %s\<cr>")]], color))
end

a.nvim_create_autocmd({ 'TabEnter', }, {
  callback = function()
    changecolorscheme()
  end,
})
