local a = vim.api
local s = vim.keymap.set

local diffview_loaded = nil

local sta

local diffview = function(params)
  if not diffview_loaded then
    diffview_loaded = 1
    sta, Do_diffview = pcall(require, 'do_diffview')
    if not sta then
      print(Do_diffview)
      return
    end
  end
  if not Do_diffview then
    return
  end
  Do_diffview.run(params)
end

a.nvim_create_user_command('DiffvieW', function(params)
  diffview(params['fargs'])
end, { nargs = "*", })

local opt = { silent = true }


s({ 'n', 'v' }, '<leader>gi', ':DiffvieW filehistory<cr>', opt)
s({ 'n', 'v' }, '<leader>go', ':DiffvieW open<cr>', opt)
s({ 'n', 'v' }, '<leader>gq', ':DiffvieW quit<cr>', opt)

s({ 'n', 'v' }, '<leader>gT', ':DiffvieW toggle_history_cnt<cr>', opt)
s({ 'n', 'v' }, '<leader>ge', ':DiffvieW DiffviewRefresh<cr>', opt)
s({ 'n', 'v' }, '<leader>gl', ':DiffvieW DiffviewToggleFiles<cr>', opt)
