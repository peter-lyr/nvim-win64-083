local s = vim.keymap.set
local o = { silent = true }

s({ 'n', 'v' }, '<leader>p', '<c-w>p', o)

s({ 'n', 'v' }, '<leader>w', ':<c-u>call bufferjump#up(1)<cr>', o)
s({ 'n', 'v' }, '<leader>s', ':<c-u>call bufferjump#down(1)<cr>', o)
s({ 'n', 'v' }, '<leader>a', ':<c-u>call bufferjump#left(1)<cr>', o)
s({ 'n', 'v' }, '<leader>d', ':<c-u>call bufferjump#right(1)<cr>', o)

s({ 'n', 'v' }, '<leader>o', ':<c-u>call bufferjump#maxheight()<cr>', o)
s({ 'n', 'v' }, '<leader>i', ':<c-u>call bufferjump#samewidthheight()<cr>', o)
s({ 'n', 'v' }, '<leader>u', ':<c-u>call bufferjump#maxwidth()<cr>', o)

s({ 'n', 'v' }, '<leader><leader>o', ':<c-u>call bufferjump#miximize(1)<cr>', o)
s({ 'n', 'v' }, '<leader><leader>i', ':<c-u>call bufferjump#miximize(0)<cr>', o)

s({ 'n', 'v' }, '<leader><leader><leader>i', ':<c-u>call bufferjump#samewidthheightfix()<cr>', o)

s({ 'n', 'v' }, '<leader><leader>w', ':<c-u>call bufferjump#winfixheight()<cr>', o)
s({ 'n', 'v' }, '<leader><leader>s', ':<c-u>call bufferjump#nowinfixheight()<cr>', o)
s({ 'n', 'v' }, '<leader><leader>d', ':<c-u>call bufferjump#winfixwidth()<cr>', o)
s({ 'n', 'v' }, '<leader><leader>a', ':<c-u>call bufferjump#nowinfixwidth()<cr>', o)
