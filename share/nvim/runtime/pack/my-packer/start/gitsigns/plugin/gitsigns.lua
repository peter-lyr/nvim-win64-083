local a = vim.api
local s = vim.keymap.set

local gitsigns_cursormoved = nil
local gitsigns_loaded = nil

local sta
local do_gitsigns

local gitsigns = function(cmd, refresh)
  if not gitsigns_loaded then
    gitsigns_loaded = 1
    a.nvim_del_autocmd(gitsigns_cursormoved)
    sta, do_gitsigns = pcall(require, 'do_gitsigns')
    if not sta then
      print(do_gitsigns)
      return
    end
  end
  if not do_gitsigns or do_gitsigns == false then
    return
  end
  do_gitsigns.run(cmd, refresh)
end

a.nvim_create_user_command('GitsignS', function(params)
  local fargs = params['fargs']
  local cmd = ''
  local refresh = ''
  for i, v in ipairs(params['fargs']) do
    if i < #fargs then
      cmd = cmd .. ' ' .. v
    else
      refresh = v
    end
  end
  gitsigns(cmd, refresh)
end, { nargs = '*', })

gitsigns_cursormoved = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    gitsigns()
  end,
})


local opt = { silent = true }

s({ 'n', 'v' }, '<leader>gr', ':<c-u>GitsignS reset_hunk 1<cr>', opt)
s({ 'n', 'v' }, '<leader>gR', ':<c-u>GitsignS reset_buffer 1<cr>', opt)
s({ 'n', 'v' }, '<leader>k', ':<c-u>GitsignS prev_hunk 0<cr>', opt)
s({ 'n', 'v' }, '<leader>j', ':<c-u>GitsignS next_hunk 0<cr>', opt)
s({ 'n', 'v' }, '<leader>gp', ':<c-u>GitsignS preview_hunk 0<cr>', opt)
s({ 'n', 'v' }, '<leader>gx', ':<c-u>GitsignS select_hunk 0<cr>', opt)
s({ 'n', 'v' }, '<leader>gd', ':<c-u>GitsignS diffthis 0<cr>', opt)
s({ 'n', 'v' }, '<leader>gD', ':<c-u>GitsignS diffthis HEAD~1 0<cr>', opt)
s({ 'n', 'v' }, '<leader>gtd', ':<c-u>GitsignS toggle_deleted 0<cr>', opt)
s({ 'n', 'v' }, '<leader>gtb', ':<c-u>GitsignS toggle_current_line_blame 0<cr>', opt)
