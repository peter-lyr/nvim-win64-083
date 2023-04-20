local a = vim.api
local s = vim.keymap.set

local aerial_cursormoved = nil

aerial_cursormoved = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    a.nvim_del_autocmd(aerial_cursormoved)
    local sta, do_aerial = pcall(require, 'do_aerial')
    if not sta then
      print(do_aerial)
    end
  end,
})

s({ 'n', 'v' }, '<leader>,', ':AerialToggle float<cr>')
s({ 'n', 'v' }, '<leader><', ':AerialCloseAll<cr>')
s({ 'n', 'v' }, ']a', ':AerialNext<cr>')
s({ 'n', 'v' }, '[a', ':AerialPrev<cr>')
