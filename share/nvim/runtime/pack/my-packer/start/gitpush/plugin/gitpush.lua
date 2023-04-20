local a = vim.api
local f = vim.fn
local g = vim.g
local s = vim.keymap.set

local gitpush_loaded = nil
local gitpush_cursormoved = nil

local sta

g.gitpush_lua = f['expand']('<sfile>')

local gitpush = function(params)
  if not gitpush_loaded then
    gitpush_loaded = 1
    a.nvim_del_autocmd(gitpush_cursormoved)
    sta, Do_gitpush = pcall(require, 'do_gitpush')
    if not sta then
      print(Do_gitpush)
      return
    end
  end
  if not Do_gitpush then
    return
  end
  Do_gitpush.run(params)
end

a.nvim_create_user_command('GitpusH', function(params)
  gitpush(params['fargs'])
end, { nargs = '*', })

gitpush_cursormoved = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    gitpush()
  end,
})


local opt = { silent = true }

s({ 'n', 'v' }, '<leader>g1', ':GitpusH add_commit_push<cr>', opt)
s({ 'n', 'v' }, '<leader>g2', ':GitpusH commit_push<cr>', opt)
s({ 'n', 'v' }, '<leader>g3', ':GitpusH just_push<cr>', opt)
s({ 'n', 'v' }, '<leader>g4', ':GitpusH add_commit<cr>', opt)
s({ 'n', 'v' }, '<leader>g5', ':GitpusH just_commit<cr>', opt)
s({ 'n', 'v' }, '<leader>gI', ':GitpusH git_init<cr>', opt)
s({ 'n', 'v' }, '<leader>g<f1>', ':!git log --all --graph --decorate --oneline && pause<cr>', opt)
