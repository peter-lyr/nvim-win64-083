local a = vim.api
local c = vim.cmd
local f = vim.fn

local timer = vim.loop.new_timer()
timer:start(100, 100, function()
  vim.schedule(function()
    f['statusline#ro']()
  end)
end)

a.nvim_create_autocmd({ 'WinEnter', 'BufEnter', 'VimResized' }, {
  callback = function()
    f['statusline#watch']()
  end,
})

Colors = {}

local by_filename = require("nvim-web-devicons-light").icons_by_filename
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

a.nvim_create_autocmd({ 'ColorScheme', }, {
  callback = function()
    statuslinecolor()
  end,
})

statuslinecolor()
