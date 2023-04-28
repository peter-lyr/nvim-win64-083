local a = vim.api
local s = vim.keymap.set
local g = vim.g
local f = vim.fn

g.telescope_lua = f['expand']('<sfile>')

local telescope_loaded
local telescope_cursormoved = nil

package.loaded['do_telescope'] = nil


local telescope = function(params)
  if not telescope_loaded then
    local sta
    telescope_loaded = 1
    a.nvim_del_autocmd(telescope_cursormoved)
    sta, Do_telescope = pcall(require, 'do_telescope')
    if not sta then
      print('no do_telescope:', Do_telescope)
      return
    end
  end
  if not Do_telescope then
    return
  end
  Do_telescope.run(params)
end

a.nvim_create_user_command('TelescopE', function(params)
  telescope(params['fargs'])
end, { nargs = '*', })

telescope_cursormoved = a.nvim_create_autocmd({ 'InsertEnter', 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    telescope()
  end,
})

local opt = { silent = true }

s({ 'n', 'v' }, '<a-/>', ':<c-u>TelescopE search_history<cr>', opt)
s({ 'n', 'v' }, '<a-c>', ':<c-u>TelescopE command_history<cr>', opt)
s({ 'n', 'v' }, '<a-C>', ':<c-u>TelescopE commands<cr>', opt)

s({ 'n', 'v' }, '<a-o>', ':<c-u>TelescopE oldfiles previewer=false<cr>', opt)
s({ 'n', 'v' }, '<a-k>', ':<c-u>TelescopE find_files previewer=false<cr>', opt)
s({ 'n', 'v' }, '<a-j>', ':<c-u>TelescopE buffers cwd_only=true sort_mru=true ignore_current_buffer=true<cr>', opt)
s({ 'n', 'v' }, '<a-J>', ':<c-u>TelescopE buffers<cr>', opt)

s({ 'n', 'v' }, '<a-;>k', ':<c-u>TelescopE git_files previewer=false<cr>', opt)
s({ 'n', 'v' }, '<a-;>i', ':<c-u>TelescopE git_commits<cr>', opt)
s({ 'n', 'v' }, '<a-;>o', ':<c-u>TelescopE git_bcommits<cr>', opt)
s({ 'n', 'v' }, '<a-;>h', ':<c-u>TelescopE git_branches<cr>', opt)
s({ 'n', 'v' }, '<a-;>j', ':<c-u>TelescopE git_status previewer=false<cr>', opt)

s({ 'n', 'v' }, '<a-l>', ':<c-u>TelescopE live_grep shorten_path=true word_match=-w only_sort_text=true search= grep_open_files=true<cr>', opt)
s({ 'n', 'v' }, '<a-L>', ':<c-u>TelescopE my live_grep<cr>', opt)
s({ 'n', 'v' }, '<a-i>', ':<c-u>TelescopE grep_string shorten_path=true word_match=-w only_sort_text=true search= grep_open_files=true<cr>', opt)
s({ 'n', 'v' }, '<a-I>', ':<c-u>TelescopE my grep_string<cr>', opt)

s({ 'n', 'v' }, '<a-q>', ':<c-u>TelescopE quickfix<cr>', opt)
s({ 'n', 'v' }, '<a-Q>', ':<c-u>TelescopE quickfixhistory<cr>', opt)

s({ 'n', 'v' }, '<a-\'>a', ':<c-u>TelescopE builtin<cr>', opt)
s({ 'n', 'v' }, '<a-\'>b', ':<c-u>TelescopE lsp_document_symbols<cr>', opt)
s({ 'n', 'v' }, '<a-\'>c', ':<c-u>TelescopE colorscheme<cr>', opt)
s({ 'n', 'v' }, '<a-\'>d', ':<c-u>TelescopE diagnostics<cr>', opt)
s({ 'n', 'v' }, '<a-\'>f', ':<c-u>TelescopE filetypes<cr>', opt)
s({ 'n', 'v' }, '<a-\'>h', ':<c-u>TelescopE help_tags<cr>', opt)
s({ 'n', 'v' }, '<a-\'>j', ':<c-u>TelescopE jumplist<cr>', opt)
s({ 'n', 'v' }, '<a-\'>m', ':<c-u>TelescopE keymaps<cr>', opt)
s({ 'n', 'v' }, '<a-\'>o', ':<c-u>TelescopE vim_options<cr>', opt)
s({ 'n', 'v' }, '<a-\'>p', ':<c-u>TelescopE planets<cr>', opt)
s({ 'n', 'v' }, '<a-\'>r', ':<c-u>TelescopE lsp_references<cr>', opt)
s({ 'n', 'v' }, '<a-\'>z', ':<c-u>TelescopE current_buffer_fuzzy_find<cr>', opt)


s({ 'n', 'v' }, '<a-s-k>', ':<c-u>TelescopE projects<cr>', opt)


s({ 'n', 'v' }, '<a-n>', ':<c-u>TelescopE vim_bookmarks current_file<cr>', opt)
s({ 'n', 'v' }, '<a-m>', ':<c-u>TelescopE vim_bookmarks all<cr>', opt)


s({ 'n', 'v' }, '<a-,>', ':<c-u>TelescopE aerial<cr>', opt)


s({ 'n', 'v' }, '<a-\\>', ':<c-u>TelescopE open<cr>', opt)
