local a = vim.api
local s = vim.keymap.set

local sta = nil
local do_markdowntable = nil
local markdowntable_cursormoved = nil
local markdowntable_loaded = nil

local markdowntable = function(params)
  if not markdowntable_loaded then
    markdowntable_loaded = 1
    a.nvim_del_autocmd(markdowntable_cursormoved)
    sta, do_markdowntable = pcall(require, 'do_markdowntable')
    if not sta then
      print(do_markdowntable)
      return
    end
  end
  if not do_markdowntable then
    return
  end
  do_markdowntable.run(params)
end

markdowntable_cursormoved = a.nvim_create_autocmd({ 'CursorMoved' }, {
  callback = function()
    a.nvim_del_autocmd(markdowntable_cursormoved)
    markdowntable()
  end,
})

a.nvim_create_user_command('MarkdowntablE', function(params)
  markdowntable(params['fargs'])
end, { nargs = '*', })

local opt = { silent = true }

s({ 'n', 'v' }, '<leader><leader>ta', ':<c-u>MarkdowntablE align<cr>', opt)
