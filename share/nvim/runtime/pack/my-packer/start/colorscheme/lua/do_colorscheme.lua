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

local colors = {}

local changecolorscheme = function(force)
  local cwd = string.lower(string.gsub(vim.loop.cwd(), '\\', '/'))
  if not vim.tbl_contains(vim.tbl_keys(colors), cwd) or force == true then
    local color
    for _=1, 5 do
      color = ColorSchemes[math.random(#ColorSchemes)]
      if not string.match(color, 'light') then
        break
      end
    end
    c(string.format([[call feedkeys(":\<c-u>colorscheme %s\<cr>")]], color))
    colors[cwd] = color
  else
    c(string.format([[call feedkeys(":\<c-u>colorscheme %s\<cr>")]], colors[cwd]))
  end
end

a.nvim_create_autocmd({ 'TabEnter', }, {
  callback = function()
    changecolorscheme(false)
  end,
})

local s = vim.keymap.set
local opt = { silent = true }
s({ 'n', 'v', 'i' }, '<leader>bw', function() changecolorscheme(true) end, opt)
