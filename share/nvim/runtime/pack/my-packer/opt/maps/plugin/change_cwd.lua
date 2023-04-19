local s = vim.keymap.set
local o = { silent = true }

s({ 'n', 'v' }, 'c.', ':try|cd %:h|ec getcwd()|catch|endtry<cr>', o)
s({ 'n', 'v' }, 'cu', ':try|cd ..|ec getcwd()|catch|endtry<cr>', o)
s({ 'n', 'v' }, 'c-', ':try|cd -|ec getcwd()|catch|endtry<cr>', o)
