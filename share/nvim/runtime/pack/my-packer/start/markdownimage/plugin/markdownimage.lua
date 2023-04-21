local g = vim.g
local a = vim.api
local s = vim.keymap.set

local do_markdownimage
local sta
local loaded_do_markdownimage

g.markdownimage_lua = vim.fn['expand']('<sfile>')

local markdownimage_exe = function(params)
  if not loaded_do_markdownimage then
    loaded_do_markdownimage = 1
    sta, do_markdownimage = pcall(require, 'do_markdownimage')
    if not sta then
      print('no do_markdownimage')
      return
    end
  end
  if not do_markdownimage or do_markdownimage == false then
    return
  end
  do_markdownimage.getimage(params)
end

a.nvim_create_user_command('MarkdownimagE', function(params)
  markdownimage_exe(params['fargs'])
end, { nargs = "*", })

local opt = { silent = true }

s({ 'n', 'v' }, '<leader><f3>', ':MarkdownimagE sel_png append<cr>', opt)
s({ 'n', 'v' }, '<leader><leader><f3>', ':MarkdownimagE sel_jpg append<cr>', opt)
