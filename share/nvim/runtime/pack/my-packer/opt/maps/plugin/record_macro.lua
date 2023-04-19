local s = vim.keymap.set
local o = { silent = true }

s({ 'n', 'v' }, 'q', '<nop>', o)
s({ 'n', 'v' }, 'Q', 'q', o)
