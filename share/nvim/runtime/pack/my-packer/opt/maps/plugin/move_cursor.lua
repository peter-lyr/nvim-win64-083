local s = vim.keymap.set
local o = { silent = true }

s({ 'n', 'v', }, '<c-j>', '5j', o)
s({ 'n', 'v', }, '<c-k>', '5k', o)
s({ 't', 'c', 'i' }, '<a-k>', '<UP>', o)
s({ 't', 'c', 'i' }, '<a-j>', '<DOWN>', o)
s({ 't', 'c', 'i' }, '<a-s-k>', '<UP><UP><UP><UP><UP>', o)
s({ 't', 'c', 'i' }, '<a-s-j>', '<DOWN><DOWN><DOWN><DOWN><DOWN>', o)
s({ 't', 'c', 'i' }, '<a-i>', '<HOME>', o)
s({ 't', 'c', 'i' }, '<a-s-i>', '<HOME>', o)
s({ 't', 'c', 'i' }, '<a-o>', '<END>', o)
s({ 't', 'c', 'i' }, '<a-s-o>', '<END>', o)
s({ 't', 'c', 'i' }, '<a-l>', '<RIGHT>', o)
s({ 't', 'c', 'i' }, '<a-h>', '<LEFT>', o)
s({ 't', 'c', 'i' }, '<a-s-l>', '<c-RIGHT>', o)
s({ 't', 'c', 'i' }, '<a-s-h>', '<c-LEFT>', o)
s({ 'v', }, '<c-l>', 'L', o)
s({ 'v', }, '<c-h>', 'H', o)
s({ 'v', }, '<c-g>', 'G', o)
s({ 'v', }, '<c-m>', 'M', o)