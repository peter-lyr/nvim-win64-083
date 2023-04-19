local s = vim.keymap.set

s('v', 'm', '<esc>')

s({ 'i', 'c', }, 'ql', '<esc><esc>')
s({ 'i', 'c', }, 'qL', '<esc><esc>')
s({ 'i', 'c', }, 'Ql', '<esc><esc>')
s({ 'i', 'c', }, 'QL', '<esc><esc>')
s('t', 'ql', '<c-\\><c-n>')
s('t', 'qL', '<c-\\><c-n>')
s('t', 'Ql', '<c-\\><c-n>')
s('t', 'QL', '<c-\\><c-n>')

s({ 'i', 'c' }, '<a-m>', '<esc><esc>')
s('t', '<esc>', '<c-\\><c-n>')
s('t', '<a-m>', '<c-\\><c-n>')
