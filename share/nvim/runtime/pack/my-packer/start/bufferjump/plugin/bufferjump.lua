local s = vim.keymap.set
local o = { silent = true }

s({ 'n', 'v' }, '<leader>p', '<c-w>p', o)

s({ 'n', 'v' }, '<leader>w', ':call bufferjump#up(1)<cr>', o)
s({ 'n', 'v' }, '<leader>s', ':call bufferjump#down(1)<cr>', o)
s({ 'n', 'v' }, '<leader>a', ':call bufferjump#left(1)<cr>', o)
s({ 'n', 'v' }, '<leader>d', ':call bufferjump#right(1)<cr>', o)

s({ 'n', 'v' }, '<leader>o', ':call bufferjump#maxheight()<cr>', o)
s({ 'n', 'v' }, '<leader>i', ':call bufferjump#samewidthheight()<cr>', o)
s({ 'n', 'v' }, '<leader>u', ':call bufferjump#maxwidth()<cr>', o)

s({ 'n', 'v' }, '<leader><leader>o', ':call bufferjump#miximize(1)<cr>', o)
s({ 'n', 'v' }, '<leader><leader>i', ':call bufferjump#miximize(0)<cr>', o)

s({ 'n', 'v' }, '<leader><leader><leader>i', ':call bufferjump#samewidthheightfix()<cr>', o)

s({ 'n', 'v' }, '<leader><leader>w', ':call bufferjump#winfixheight()<cr>', o)
s({ 'n', 'v' }, '<leader><leader>s', ':call bufferjump#nowinfixheight()<cr>', o)
s({ 'n', 'v' }, '<leader><leader>d', ':call bufferjump#winfixwidth()<cr>', o)
s({ 'n', 'v' }, '<leader><leader>a', ':call bufferjump#nowinfixwidth()<cr>', o)
