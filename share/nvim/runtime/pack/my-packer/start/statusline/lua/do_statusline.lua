local a = vim.api
local c = vim.cmd
local f = vim.fn
local o = vim.opt

local timer = vim.loop.new_timer()
timer:start(100, 100, function()
  vim.schedule(function()
    o.ro = o.ro:get()
  end)
end)

a.nvim_create_autocmd({ 'WinEnter', 'BufEnter', 'VimResized' }, {
  callback = function()
    f['statusline#watch']()
  end,
})

Colors = {}

local sta, light = pcall(require, "nvim-web-devicons-light")
if not sta then
  print(light)
  a.nvim_create_autocmd({ 'ColorScheme', 'TabEnter', }, {
    callback = function()
      f['statusline#color']()
    end,
  })
  return
end

local by_filename = light.icons_by_filename

for _, v in pairs(by_filename) do
  table.insert(Colors, v['color'])
end

MyHi = {
  "MyHiLiBufNr",
  "MyHiLiDate",
  "MyHiLiTime",
  "MyHiLiWeek",
  "MyHiLiFnameHead",
  "MyHiLiFileFormat",
  "MyHiLiFileEncoding",
  "MyHiLiLineCol",
  "MyHiLiBotTop",
}

local statuslinecolor = function()
  for _, hiname in ipairs(MyHi) do
    local color = Colors[math.random(#Colors)]
    local opt = { fg = color }
    vim.api.nvim_set_hl(0, hiname, opt)
  end
  c[[
    hi MyHiLiFnameTailActive   gui=bold guifg=#ff9933 guibg=NONE
    hi MyHiLiFnameTailInActive gui=NONE guifg=#996633 guibg=NONE
    hi StatusLine              gui=NONE guibg=NONE guifg=NONE
    hi StatusLineNC            gui=NONE guibg=NONE guifg=gray
  ]]
end

a.nvim_create_autocmd({ 'ColorScheme', 'TabEnter', }, {
  callback = function()
    statuslinecolor()
  end,
})

statuslinecolor()
