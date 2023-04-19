local a = vim.api
local f = vim.fn
local g = vim.g
local s = vim.keymap.set

local o = { silent = true }

s({ 'n', 'v' }, '<a-y>', '"+y', o)
s({ 'n', 'v' }, '<a-p>', '"+p', o)
s({ 'n', 'v' }, '<a-s-p>', '"+P', o)

s({ 'c', 'i' }, '<a-w>', '<c-r>=g:word<cr>', o)
s({ 'c', 'i' }, '<a-v>', '<c-r>"', o)
s({ 't', }, '<a-v>', '<c-\\><c-n>pi', o)
s({ 'c', 'i' }, '<a-=>', '<c-r>+', o)
s({ 't', }, '<a-=>', '<c-\\><c-n>"+pi', o)
s({ 'n', 'v' }, '<a-z>', '"zy', o)
s({ 'c', 'i' }, '<a-z>', '<c-r>z', o)
s({ 't', }, '<a-z>', '<c-\\><c-n>"zpi', o)

s({ 'n', 'v' }, '<leader>y', '<esc>:let @+ = expand("%:t")<cr>', o)
s({ 'n', 'v' }, '<leader>gy', '<esc>:let @+ = substitute(nvim_buf_get_name(0), "/", "\\\\", "g")<cr>', o)

local buf_leave = function()
  g.word = f['expand']('<cword>')
end

a.nvim_create_autocmd({ "BufLeave" }, {
  callback = buf_leave,
})
