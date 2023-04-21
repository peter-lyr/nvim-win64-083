local g = vim.g
local a = vim.api
local s = vim.keymap.set

local do_markdownpreview
local loaded_do_markdownpreview

local sta

g.markdownpreview_lua = vim.fn['expand']('<sfile>')

local markdownpreview_exe = function(cmd)
  if not loaded_do_markdownpreview then
    loaded_do_markdownpreview = 1
    sta, do_markdownpreview = pcall(require, 'do_markdownpreview')
    if not sta then
      print(do_markdownpreview)
      return
    end
  end
  if not do_markdownpreview then
    return
  end
  do_markdownpreview.do_markdownpreview(cmd)
end

a.nvim_create_user_command('MPreview', function(params)
  markdownpreview_exe(unpack(params['fargs']))
end, { nargs = "*", })

s({ 'n', 'v' }, '<f3>', ":MPreview MarkdownPreviewToggle<cr>", { silent = true })


g.mkdp_theme = 'light'
g.mkdp_auto_close = 0
