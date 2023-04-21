local s = vim.keymap.set
local o = { silent = true }

s({ 'n', 'v' }, '<leader>S', 'S', o) -- 可用C代替
s({ 'n', 'v' }, 'S', 's', o)
s({ 'n', 'v' }, '<leader>F', 'F', o)
s({ 'n', 'v' }, 'F', 'f', o)
