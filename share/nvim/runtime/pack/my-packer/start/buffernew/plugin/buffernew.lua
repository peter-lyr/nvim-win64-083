local a = vim.api
local s = vim.keymap.set

local buffernew_loaded
local buffernew_cursormoved
local do_buffernew

local sta

local buffernew = function(params)
  if not buffernew_loaded then
    buffernew_loaded = 1
    a.nvim_del_autocmd(buffernew_cursormoved)
    sta, do_buffernew = pcall(require, 'do_buffernew')
    if not sta then
      print(do_buffernew)
      return
    end
  end
  if not do_buffernew then
    return
  end
  do_buffernew.run(params)
end

a.nvim_create_user_command('BufferneW', function(params)
  buffernew(params['fargs'])
end, { nargs = '*', })

buffernew_cursormoved = a.nvim_create_autocmd({ 'CursorMoved', 'CursorHold', 'FocusLost' }, {
  callback = function()
    buffernew()
  end,
})


local opt = { silent = true }

s({ 'n', 'v' }, '<leader><leader><leader>z', ':<c-u>BufferneW do<cr>', opt)

s({ 'n', 'v' }, '<leader>bn', ':<c-u>leftabove split<cr>', opt)
s({ 'n', 'v' }, '<leader>bm', ':<c-u>leftabove new<cr>', opt)
s({ 'n', 'v' }, '<leader>bo', ':<c-u>leftabove vsplit<cr>', opt)
s({ 'n', 'v' }, '<leader>bp', ':<c-u>leftabove vnew<cr>', opt)

s({ 'n', 'v' }, '<leader>ba', ':<c-u>split<cr>', opt)
s({ 'n', 'v' }, '<leader>bb', ':<c-u>new<cr>', opt)
s({ 'n', 'v' }, '<leader>bc', ':<c-u>vsplit<cr>', opt)
s({ 'n', 'v' }, '<leader>bd', ':<c-u>vnew<cr>', opt)
s({ 'n', 'v' }, '<leader>be', '<c-w>s<c-w>t', opt)
s({ 'n', 'v' }, '<leader>bf', ':<c-u>tabnew<cr>', opt)

s({ 'n', 'v' }, '<leader>bg', ':<c-u>BufferneW copy_fpath<cr>', opt)
s({ 'n', 'v' }, '<leader>bi', ':<c-u>BufferneW here<cr>', opt)
s({ 'n', 'v' }, '<leader>bk', ':<c-u>BufferneW up<cr>', opt)
s({ 'n', 'v' }, '<leader>bj', ':<c-u>BufferneW down<cr>', opt)
s({ 'n', 'v' }, '<leader>bh', ':<c-u>BufferneW left<cr>', opt)
s({ 'n', 'v' }, '<leader>bl', ':<c-u>BufferneW right<cr>', opt)

s({ 'n', 'v' }, '<leader>x', ':<c-u>BufferneW copy_fpath_silent<cr>', opt)
s({ 'n', 'v' }, '<leader>X', ':<c-u>tabclose<cr>', opt)
s({ 'n', 'v' }, '<a-bs>', ':<c-u>bw!<cr>', opt)
s({ 'n', 'v' }, 'ZX', ':<c-u>qa!<cr>', opt)
