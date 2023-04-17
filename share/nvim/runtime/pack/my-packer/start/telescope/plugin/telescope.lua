local a = vim.api
local g = vim.g
local s = vim.keymap.set

local telescope = function(params)
  if not g.telescope_loaded then
    local sta
    g.telescope_loaded = 1
    a.nvim_del_autocmd(g.telescope_cursormoved)
    sta, Do_telescope = pcall(require, 'do_telescope')
    if not sta then
      print("no do_telescope:", Do_telescope)
      return
    end
  end
  if not Do_telescope then
    return
  end
  Do_telescope.run(params)
end

if not g.telescope_startup then
  g.telescope_startup = 1
  g.telescope_cursormoved = a.nvim_create_autocmd({ "CursorMoved" }, {
    callback = function()
      a.nvim_del_autocmd(g.telescope_cursormoved)
      telescope()
    end,
  })
end

a.nvim_create_user_command('TelescopE', function(params)
  telescope(params['fargs'])
end, { nargs = "*", })


local opt = { silent = true }

s({ 'n', 'v' }, '<a-/>', ":TelescopE search_history<cr>", opt)
s({ 'n', 'v' }, '<a-c>', ":TelescopE command_history<cr>", opt)
s({ 'n', 'v' }, '<a-C>', ":TelescopE commands<cr>", opt)

s({ 'n', 'v' }, '<a-o>', ":TelescopE oldfiles<cr>", opt)
s({ 'n', 'v' }, '<a-k>', ":TelescopE find_files<cr>", opt)
s({ 'n', 'v' }, '<a-j>', ":TelescopE buffers<cr>", opt)

s({ 'n', 'v' }, '<a-;>k', ":TelescopE git_files<cr>", opt)
s({ 'n', 'v' }, '<a-;>i', ":TelescopE git_commits<cr>", opt)
s({ 'n', 'v' }, '<a-;>o', ":TelescopE git_bcommits<cr>", opt)
s({ 'n', 'v' }, '<a-;>h', ":TelescopE git_branches<cr>", opt)
s({ 'n', 'v' }, '<a-;>j', ":TelescopE git_status<cr>", opt)

s({ 'n', 'v' }, '<a-l>', ":TelescopE live_grep<cr>", opt)
s({ 'n', 'v' }, '<a-i>', ":TelescopE grep_string<cr>", opt)

s({ 'n', 'v' }, '<a-q>', ":TelescopE quickfix<cr>", opt)
s({ 'n', 'v' }, '<a-Q>', ":TelescopE quickfixhistory<cr>", opt)

s({ 'n', 'v' }, '<a-\'>a', ":TelescopE builtin<cr>", opt)
s({ 'n', 'v' }, '<a-\'>b', ":TelescopE lsp_document_symbols<cr>", opt)
s({ 'n', 'v' }, '<a-\'>c', ":TelescopE colorscheme<cr>", opt)
s({ 'n', 'v' }, '<a-\'>d', ":TelescopE diagnostics<cr>", opt)
s({ 'n', 'v' }, '<a-\'>f', ":TelescopE filetypes<cr>", opt)
s({ 'n', 'v' }, '<a-\'>h', ":TelescopE help_tags<cr>", opt)
s({ 'n', 'v' }, '<a-\'>j', ":TelescopE jumplist<cr>", opt)
s({ 'n', 'v' }, '<a-\'>m', ":TelescopE keymaps<cr>", opt)
s({ 'n', 'v' }, '<a-\'>o', ":TelescopE vim_options<cr>", opt)
s({ 'n', 'v' }, '<a-\'>p', ":TelescopE planets<cr>", opt)
s({ 'n', 'v' }, '<a-\'>r', ":TelescopE lsp_references<cr>", opt)
s({ 'n', 'v' }, '<a-\'>z', ":TelescopE current_buffer_fuzzy_find<cr>", opt)


s({ 'n', 'v' }, '<a-s-k>', ":TelescopE projects<cr>", opt)


s({ 'n', 'v' }, '<a-m>', ":TelescopE vim_bookmarks current_file<cr>", opt)
s({ 'n', 'v' }, '<a-M>', ":TelescopE vim_bookmarks all<cr>", opt)
