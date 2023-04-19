local s = vim.keymap.set
local o = { silent = true }

s({ 'n', 'v' }, '<f5>', '<cmd>:e!<cr>', o)
