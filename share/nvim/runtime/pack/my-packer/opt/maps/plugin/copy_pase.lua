local a = vim.api
local f = vim.fn
local g = vim.g
local s = vim.keymap.set

s({ 'n', 'v' }, '<a-y>', '"+y')
s({ 'n', 'v' }, '<a-p>', '"+p')
s({ 'n', 'v' }, '<a-s-p>', '"+P')

s({ 'c', 'i' }, '<a-w>', '<c-r>=g:word<cr>')
s({ 'c', 'i' }, '<a-v>', '<c-r>"')
s({ 't', }, '<a-v>', '<c-\\><c-n>pi')
s({ 'c', 'i' }, '<a-=>', '<c-r>+')
s({ 't', }, '<a-=>', '<c-\\><c-n>"+pi')
s({ 'n', 'v' }, '<a-z>', '"zy')
s({ 'c', 'i' }, '<a-z>', '<c-r>z')
s({ 't', }, '<a-z>', '<c-\\><c-n>"zpi')

s({ 'n', 'v' }, '<leader>y', '<esc>:let @+ = expand("%:t")<cr>')
s({ 'n', 'v' }, '<leader>gy', '<esc>:let @+ = substitute(nvim_buf_get_name(0), "/", "\\\\", "g")<cr>')

local buf_leave = function()
  g.word = f['expand']('<cword>')
end

a.nvim_create_autocmd({ "BufLeave" }, {
  callback = buf_leave,
})
