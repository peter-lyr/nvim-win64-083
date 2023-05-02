local a = vim.api
local c = vim.cmd
local s = vim.keymap.set

local lasttab = 0

local opt = { silent = true }

s({ 'n', 'v', }, '<leader><f1>', '1gt', opt)
s({ 'n', 'v', }, '<leader><f2>', '2gt', opt)
s({ 'n', 'v', }, '<leader><f3>', '3gt', opt)
s({ 'n', 'v', }, '<leader><f4>', '4gt', opt)
s({ 'n', 'v', }, '<leader><f5>', '5gt', opt)
s({ 'n', 'v', }, '<leader><f6>', '6gt', opt)
s({ 'n', 'v', }, '<leader><f7>', '7gt', opt)
s({ 'n', 'v', }, '<leader><f8>', '8gt', opt)
s({ 'n', 'v', }, '<leader><f9>', '9gt', opt)
s({ 'n', 'v', }, '<leader><f10>', '10gt', opt)
s({ 'n', 'v', }, '<leader><f11>', '11gt', opt)
s({ 'n', 'v', }, '<leader><f12>', '<cmd>:tablast<cr>', opt)

local space_enter = function()
  if lasttab ~= 0 then
    pcall(c, "tabn " .. lasttab)
  end
end

s({ 'n', 'v', }, '<leader><cr>', space_enter, opt)

s({ 'n', 'v' }, '<cr>', ':<c-u>tabnext<cr>', opt)
s({ 'n', 'v' }, '<s-cr>', ':<c-u>tabprevious<cr>', opt)

s({ 'n', 'v', }, '<c-s-h>', ':<c-u>try <bar> tabmove - <bar> catch <bar> endtry<cr>', opt)
s({ 'n', 'v', }, '<c-s-l>', ':<c-u>try <bar> tabmove + <bar> catch <bar> endtry<cr>', opt)
s({ 'n', 'v', }, '<c-s-k>', 'gT', opt)
s({ 'n', 'v', }, '<c-s-j>', 'gt', opt)

a.nvim_create_autocmd({ "TabLeave" }, {
  callback = function()
    lasttab = vim.fn['tabpagenr']()
  end
})
