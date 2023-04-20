local a = vim.api
local c = vim.cmd
local s = vim.keymap.set

local lasttab = 0

local opt = { silent = true }

s({ 'n', 'v', }, '<leader>1', '1gt', opt)
s({ 'n', 'v', }, '<leader>2', '2gt', opt)
s({ 'n', 'v', }, '<leader>3', '3gt', opt)
s({ 'n', 'v', }, '<leader>4', '4gt', opt)
s({ 'n', 'v', }, '<leader>5', '5gt', opt)
s({ 'n', 'v', }, '<leader>6', '6gt', opt)
s({ 'n', 'v', }, '<leader>7', '7gt', opt)
s({ 'n', 'v', }, '<leader>8', '8gt', opt)
s({ 'n', 'v', }, '<leader>9', '9gt', opt)
s({ 'n', 'v', }, '<leader>0', '<cmd>:tablast<cr>', opt)

local space_enter = function()
  if lasttab ~= 0 then
    c("tabn " .. lasttab)
  end
end

s({ 'n', 'v', }, '<leader><cr>', space_enter, opt)

s({ 'n', 'v' }, '<cr>', ':tabnext<cr>', opt)
s({ 'n', 'v' }, '<s-cr>', ':tabprevious<cr>', opt)

s({ 'n', 'v', }, '<c-s-h>', ':try <bar> tabmove - <bar> catch <bar> endtry<cr>', opt)
s({ 'n', 'v', }, '<c-s-l>', ':try <bar> tabmove + <bar> catch <bar> endtry<cr>', opt)
s({ 'n', 'v', }, '<c-s-k>', 'gT', opt)
s({ 'n', 'v', }, '<c-s-j>', 'gt', opt)

a.nvim_create_autocmd({ "TabLeave" }, {
  callback = function()
    lasttab = vim.fn['tabpagenr']()
  end
})
