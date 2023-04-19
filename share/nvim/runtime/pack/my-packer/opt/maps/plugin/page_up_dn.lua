local s = vim.keymap.set
local o = { silent = true }

s({ 'n', 'v' }, '<c-d>', '<c-u>', o)
s({ 'n', 'v' }, '<c-f>', '<c-d>', o)
s({ 'n', 'v' }, '<c-u>', '<c-b>', o)
s({ 'n', 'v' }, '<c-b>', '<c-f>', o)
