local s = vim.keymap.set
local o = { silent = true }

s({ 'n', 'v' }, '<leader>f.', ':if (&ft == "vim" || &ft == "lua") | source %:p | endif<cr>', o)
