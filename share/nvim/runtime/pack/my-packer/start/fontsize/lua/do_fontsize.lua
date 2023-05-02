local s = vim.keymap.set

local opt = { silent = true }

s({ 'n', 'v', 'i' }, '<C-ScrollWheelDown>', ':<c-u>call fontSize#change(-1)<cr>', opt)
s({ 'n', 'v', 'i' }, '<C-ScrollWheelUp>', ':<c-u>call fontSize#change(1)<cr>', opt)
s({ 'n', 'v', 'i' }, '<C-MiddleMouse>', ':<c-u>call fontSize#change(0)<cr>', opt)

s({ 'n', 'v', 'i' }, '<c-9>', ':<c-u>call fontSize#change(-2)<cr>', opt)
s({ 'n', 'v', 'i' }, '<c-->', ':<c-u>call fontSize#change(-1)<cr>', opt)
s({ 'n', 'v', 'i' }, '<c-0>', ':<c-u>call fontSize#change(0)<cr>', opt)
s({ 'n', 'v', 'i' }, '<c-=>', ':<c-u>call fontSize#change(1)<cr>', opt)
