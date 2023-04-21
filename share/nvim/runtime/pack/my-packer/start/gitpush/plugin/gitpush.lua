local a = vim.api
local f = vim.fn
local g = vim.g
local s = vim.keymap.set

local gitpush_loaded = nil
local gitpush_cursormoved = nil
local do_gitpush = nil

local sta

g.gitpush_lua = f['expand']('<sfile>')

local gitpush = function(params)
  if not gitpush_loaded then
    gitpush_loaded = 1
    a.nvim_del_autocmd(gitpush_cursormoved)
    sta, do_gitpush = pcall(require, 'do_gitpush')
    if not sta then
      print(do_gitpush)
      return
    end
  end
  if not do_gitpush then
    return
  end
  do_gitpush.run(params)
end

a.nvim_create_user_command('GitpusH', function(params)
  gitpush(params['fargs'])
end, { nargs = '*', })

gitpush_cursormoved = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    gitpush()
  end,
})

-- local start_cmd = function(cmd)
--   f['system'](string.format([[start cmd /c "%s" && pause]], cmd))
-- end


local opt = { silent = true }

s({ 'n', 'v' }, '<leader>g1', ':<c-u>GitpusH add_commit_push<cr>', opt)
s({ 'n', 'v' }, '<leader>g2', ':<c-u>GitpusH commit_push<cr>', opt)
s({ 'n', 'v' }, '<leader>g3', ':<c-u>GitpusH just_push<cr>', opt)
s({ 'n', 'v' }, '<leader>g4', ':<c-u>GitpusH add_commit<cr>', opt)
s({ 'n', 'v' }, '<leader>g5', ':<c-u>GitpusH just_commit<cr>', opt)
s({ 'n', 'v' }, '<leader>gI', ':<c-u>GitpusH git_init<cr>', opt)
s({ 'n', 'v' }, '<leader>g<f1>',
  [[:silent exe '!start cmd /c "git log --all --graph --decorate --oneline" && pause'<cr>]], opt)
-- s({ 'n', 'v' }, '<leader>g<f1>', function() start_cmd('git log --all --graph --decorate --oneline') end, opt)
