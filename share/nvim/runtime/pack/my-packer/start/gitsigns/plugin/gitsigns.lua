local a = vim.api
local s = vim.keymap.set

local gitsigns_cursormoved = nil
local gitsigns_loaded = nil

local sta

local gitsigns = function(cmd, refresh)
  if not gitsigns_loaded then
    gitsigns_loaded = 1
    a.nvim_del_autocmd(gitsigns_cursormoved)
    sta, Do_gitsigns = pcall(require, 'do_gitsigns')
    if not sta then
      print(Do_gitsigns)
      return
    end
  end
  if not Do_gitsigns then
    return
  end
  Do_gitsigns.run(cmd, refresh)
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

s({ 'n', 'v' }, '<leader>gr', ':GitsignS reset_hunk 1<cr>', opt)
s({ 'n', 'v' }, '<leader>gR', ':GitsignS reset_buffer 1<cr>', opt)
s({ 'n', 'v' }, '<leader>k', ':GitsignS prev_hunk 0<cr>', opt)
s({ 'n', 'v' }, '<leader>j', ':GitsignS next_hunk 0<cr>', opt)
s({ 'n', 'v' }, '<leader>gp', ':GitsignS preview_hunk 0<cr>', opt)
s({ 'n', 'v' }, '<leader>gx', ':GitsignS select_hunk 0<cr>', opt)
s({ 'n', 'v' }, '<leader>gd', ':GitsignS diffthis 0<cr>', opt)
s({ 'n', 'v' }, '<leader>gD', ':GitsignS diffthis HEAD~1 0<cr>', opt)
s({ 'n', 'v' }, '<leader>gtd', ':GitsignS toggle_deleted 0<cr>', opt)
s({ 'n', 'v' }, '<leader>gtb', ':GitsignS toggle_current_line_blame 0<cr>', opt)
