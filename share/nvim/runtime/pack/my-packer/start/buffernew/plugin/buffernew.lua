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

buffernew_cursormoved = a.nvim_create_autocmd({ 'CursorHold', 'FocusLost' }, {
  callback = function()
    buffernew()
  end,
})


local opt = { silent = true }

s({ 'n', 'v' }, '<leader><leader><leader>z', ':BufferneW do<cr>', opt)

s({ 'n', 'v' }, '<leader>bn', ':leftabove split<cr>', opt)
s({ 'n', 'v' }, '<leader>bm', ':leftabove new<cr>', opt)
s({ 'n', 'v' }, '<leader>bo', ':leftabove vsplit<cr>', opt)
s({ 'n', 'v' }, '<leader>bp', ':leftabove vnew<cr>', opt)

s({ 'n', 'v' }, '<leader>ba', ':split<cr>', opt)
s({ 'n', 'v' }, '<leader>bb', ':new<cr>', opt)
s({ 'n', 'v' }, '<leader>bc', ':vsplit<cr>', opt)
s({ 'n', 'v' }, '<leader>bd', ':vnew<cr>', opt)
s({ 'n', 'v' }, '<leader>be', '<c-w>s<c-w>t', opt)
s({ 'n', 'v' }, '<leader>bf', ':tabnew<cr>', opt)

s({ 'n', 'v' }, '<leader>bg', ':BufferneW copy_fpath<cr>', opt)
s({ 'n', 'v' }, '<leader>bi', ':BufferneW here<cr>', opt)
s({ 'n', 'v' }, '<leader>bk', ':BufferneW up<cr>', opt)
s({ 'n', 'v' }, '<leader>bj', ':BufferneW down<cr>', opt)
s({ 'n', 'v' }, '<leader>bh', ':BufferneW left<cr>', opt)
s({ 'n', 'v' }, '<leader>bl', ':BufferneW right<cr>', opt)

s({ 'n', 'v' }, '<leader>x', ':BufferneW copy_fpath_silent<cr>:try|hide|catch|endtry<cr>', opt)
s({ 'n', 'v' }, '<a-bs>', ':bw!<cr>', opt)
s({ 'n', 'v' }, 'ZX', ':qa!<cr>', opt)
