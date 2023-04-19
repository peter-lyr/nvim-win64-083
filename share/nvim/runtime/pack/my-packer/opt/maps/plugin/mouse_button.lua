local s = vim.keymap.set
local o = { silent = true }

s({ 'n', 'v', 'i' }, '<rightmouse>', '<leftmouse>', o)
s({ 'n', 'v', 'i' }, '<rightrelease>', '<nop>', o)
s({ 'n', 'v', 'i' }, '<middlemouse>', '<nop>', o)
