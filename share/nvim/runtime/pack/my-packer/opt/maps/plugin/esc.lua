local s = vim.keymap.set
local o = { silent = true }

s('v', 'm', '<esc>', o)

s({ 'i', 'c', }, 'ql', '<esc><esc>', o)
s({ 'i', 'c', }, 'qL', '<esc><esc>', o)
s({ 'i', 'c', }, 'Ql', '<esc><esc>', o)
s({ 'i', 'c', }, 'QL', '<esc><esc>', o)
s('t', 'ql', '<c-\\><c-n>', o)
s('t', 'qL', '<c-\\><c-n>', o)
s('t', 'Ql', '<c-\\><c-n>', o)
s('t', 'QL', '<c-\\><c-n>', o)

s({ 'i', 'c' }, '<a-m>', '<esc><esc>', o)
s('t', '<esc>', '<c-\\><c-n>', o)
s('t', '<a-m>', '<c-\\><c-n>', o)
